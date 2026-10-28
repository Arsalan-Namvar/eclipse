import { chmodSync, lstatSync, mkdirSync, readFileSync, renameSync, statSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { randomUUID } from "node:crypto";
import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";

// Supported runtime APIs only: no session-file, database, or credential reads.
// Every bound main-session factory owns its own timer and runtime identity.
// Interface evidence: can1357/oh-my-pi docs/{extensions,theme,skills}.md;
// session/session-manager.ts ReadonlySessionManager + UsageStatistics;
// modes/controllers/extension-ui-controller.ts named-theme implementation.
// https://github.com/can1357/oh-my-pi/tree/main/packages/coding-agent/src
export default function eclipse(pi: ExtensionAPI) {
    const instance = randomUUID();
    const runtime = process.env.XDG_RUNTIME_DIR;
    const directory = runtime ? join(runtime, "eclipse-omp") : undefined;
    const themePath = join(process.env.XDG_CONFIG_HOME || join(homedir(), ".config"), "quickshell", "omp-theme.json");
    let currentId: string | undefined;
    let lastReport: Record<string, unknown> | undefined;
    let timer: ReturnType<ExtensionContext["setInterval"]> | undefined;
    let themeStamp = 0;
    let warned = false;

    function publish(report: Record<string, unknown>) {
        if (!directory) return;
        mkdirSync(directory, { recursive: true, mode: 0o700 });
        const info = lstatSync(directory);
        if (!info.isDirectory() || info.isSymbolicLink() || info.uid !== process.getuid?.())
            throw new Error("OMP status directory is not owned by this user");
        chmodSync(directory, 0o700);
        const file = join(directory, `${instance}-${currentId}.json`);
        const temporary = `${file}.tmp`;
        writeFileSync(temporary, JSON.stringify(report), { mode: 0o600, flag: "w" });
        chmodSync(temporary, 0o600);
        renameSync(temporary, file);
        lastReport = report;
    }

    function end(state: string) {
        if (lastReport) publish({ ...lastReport, state, observed: Date.now() });
    }

    async function update(ctx: ExtensionContext) {
        if (ctx.agent.kind !== "main" || ctx.mode !== "tui") return;
        try {
            const id = ctx.sessionManager.getSessionId();
            if (currentId && id !== currentId) end("ended");
            currentId = id;
            const usage = ctx.sessionManager.getUsageStatistics();
            const context = ctx.getContextUsage();
            const finite = (value: unknown): number | null => typeof value === "number" && Number.isFinite(value) ? value : null;
            const capacity = finite(context?.contextWindow);
            const knownCapacity = capacity !== null && capacity > 0;
            publish({
                version: 1, id: `${instance}:${id}`, sessionId: id, pid: process.pid,
                project: ctx.sessionManager.getCwd(), name: pi.getSessionName() || ctx.sessionManager.getSessionName() || "Untitled session",
                state: ctx.isIdle() ? "idle" : "working", observed: Date.now(),
                provider: ctx.model?.provider ?? null, model: ctx.model?.id ?? null,
                tokens: usage ? finite(usage.totalTokens) : null,
                input: usage ? finite(usage.input) : null, output: usage ? finite(usage.output) : null,
                cacheRead: usage ? finite(usage.cacheRead) : null, cacheWrite: usage ? finite(usage.cacheWrite) : null,
                cost: usage ? finite(usage.cost) : null,
                context: context ? {
                    tokens: finite(context.tokens),
                    window: knownCapacity ? capacity : null,
                    percent: knownCapacity ? finite(context.percent) : null,
                } : null,
            });
            // OMP's TUI controller supports theme names, not direct Theme objects.
            // Resolve the active profile's supported theme directory and replace
            // only our generated file; never rewrite config.yml/settings.json.
            const stamp = statSync(themePath).mtimeMs;
            if (stamp !== themeStamp) {
                const contents = readFileSync(themePath, "utf8");
                const themes = join(pi.pi.getAgentDir(), "themes");
                mkdirSync(themes, { recursive: true });
                const target = join(themes, "eclipse-desktop.json");
                const temporary = `${target}.${instance}.tmp`;
                writeFileSync(temporary, contents, { mode: 0o600 });
                renameSync(temporary, target);
                const result = await ctx.ui.setTheme("eclipse-desktop");
                if (!result.success) throw new Error(result.error || "OMP rejected Eclipse theme");
                themeStamp = stamp;
            }
        } catch (error) {
            if (!warned) {
                pi.logger.warn("Eclipse desktop integration unavailable", { error: String(error) });
                warned = true;
            }
        }
    }

    pi.on("session_start", async (_event, ctx) => {
        if (ctx.agent.kind !== "main" || ctx.mode !== "tui") return;
        if (timer) ctx.clearTimer(timer);
        await update(ctx);
        timer = ctx.setInterval(() => update(ctx), 2000);
    });
    pi.on("session_switch", async (_event, ctx) => update(ctx));
    pi.on("session_shutdown", (_event, ctx) => {
        if (timer) ctx.clearTimer(timer);
        end("ended");
    });
}
