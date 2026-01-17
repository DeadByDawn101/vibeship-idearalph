# IdeaRalph MCP Server v2.0

AI-powered startup idea generation, validation, and refinement - designed for Claude Code.

**No API key required!** This MCP works natively inside Claude Code.

## How It Works

Unlike traditional MCPs that make external API calls, IdeaRalph v2.0 is a **prompt provider**. It returns structured prompts and scoring criteria that Claude (already running in Claude Code) processes directly.

```
Old way:  User → Claude Code → MCP → Anthropic API → Response (needed API key!)
New way:  User → Claude Code → MCP → Returns prompt → Claude processes it directly
```

This means:
- No API key needed
- No extra latency from double API calls
- Works offline (MCP itself doesn't need internet)
- Simpler, more reliable

## Tools Available

| Tool | Description |
|------|-------------|
| `idearalph_brainstorm` | Generate and score startup ideas for a given topic |
| `idearalph_validate` | Validate and score an existing startup idea on 10 PMF dimensions |
| `idearalph_refine` | Run the Ralph Loop to iteratively improve an idea until target score |
| `idearalph_prd` | Generate a PRD at 3 levels: napkin, science-fair, genius |
| `idearalph_architecture` | Get implementation plan with recommended Spawner skills |

## The Flow

```
Brainstorm → Validate → Refine → PRD → Architecture → Build with Spawner!
```

1. **Brainstorm**: Generate ideas in a domain
2. **Validate**: Score on 10 PMF dimensions
3. **Refine**: Iterate until score >= 9.5 (or your target)
4. **PRD**: Generate documentation (napkin → science-fair → genius)
5. **Architecture**: Get tech stack and Spawner skills for building

## Installation

### Prerequisites
- Node.js 18+
- Claude Code

### Build the Server

```bash
cd mcp-server
npm install
npm run build
```

### Configure Claude Code

Add to your Claude Code MCP settings:

**Mac/Linux**: `~/.claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "idearalph": {
      "command": "node",
      "args": ["/path/to/vibeship-idearalph/mcp-server/dist/index.js"]
    }
  }
}
```

That's it! No API key needed.

### Alternative: Claude Code CLI

```bash
claude mcp add idearalph -- node /path/to/mcp-server/dist/index.js
```

## Usage Examples

### Brainstorm Ideas
"Help me brainstorm startup ideas in the AI productivity space"
→ Claude will use `idearalph_brainstorm` to generate and score ideas

### Validate Your Idea
"Validate my startup idea: A platform that connects dog owners with local pet sitters using AI matching"
→ Claude will use `idearalph_validate` to score on 10 PMF dimensions

### Refine to Perfection
"Take this idea and refine it until it scores at least 9.5"
→ Claude will use `idearalph_refine` with mode="target" and targetScore=9.5

### Generate PRD
"Create a detailed PRD for this idea"
→ Claude will use `idearalph_prd` with your preferred level

### Get Build Plan
"Now help me plan the architecture and implementation"
→ Claude will use `idearalph_architecture` and suggest Spawner skills

## PMF Scoring Dimensions

Each idea is scored on 10 dimensions (1-10 scale):

| Dimension | What It Measures |
|-----------|------------------|
| **Problem Clarity** | How clear and well-defined is the problem? |
| **Market Size** | How large is the potential market? |
| **Uniqueness** | How differentiated from existing solutions? |
| **Feasibility** | How technically and operationally feasible? |
| **Monetization** | How clear is the path to revenue? |
| **Timing** | Is the market ready for this now? |
| **Virality** | Does it have natural word-of-mouth potential? |
| **Defensibility** | Can this build a moat over time? |
| **Team Fit** | How well does this fit an indie founder? |
| **Ralph Factor** | The X-factor - does this make Ralph excited? |

Each dimension has detailed scoring criteria (1-3, 4-6, 7-8, 9-10 bands) that guide consistent evaluation.

## PRD Levels

- **Napkin**: Quick 1-page sketch (5 min read)
- **Science Fair**: Detailed with personas, user stories, technical considerations (15 min read)
- **Genius**: Investor-ready with TAM/SAM/SOM, business model, go-to-market (30+ min read)

## Refinement Modes

- **single**: One round of feedback and improvement
- **target**: Keep iterating until target score reached (default: 9.5)
- **max**: Run all iterations for maximum polish

## Integration with Spawner

After architecture generation, IdeaRalph intelligently handles the transition to building:

### If Spawner is Available
- Offers to start building immediately
- Loads appropriate skills (supabase-backend, sveltekit, etc.)
- Smooth handoff to implementation

### If Spawner is NOT Available
IdeaRalph will:
1. Explain the benefits (FREE, 450+ specialized skills, better output)
2. Offer to install it automatically (no manual config needed!)
3. Save your work to files first
4. Provide a resume prompt to continue after restart

**User only needs to:**
1. Restart Claude Code (one keyboard shortcut)
2. Paste the resume prompt (one copy-paste)

Everything else is handled automatically.

## UX Philosophy

IdeaRalph follows these principles (see `docs/MCP_UX_PATTERNS.md`):

1. **Never dump commands** - Always ASK what user wants
2. **Do it for them** - Don't explain how, just offer to do it
3. **Always offer pause** - Users might need to step away
4. **Session continuity** - Resume prompts after any restart

```
❌ BAD: "Run spawner_load({ skill_id: 'supabase-backend' })"
✅ GOOD: "Want me to load the Supabase skill and start building?"
```

## Development

```bash
# Run in development mode
npm run dev

# Build for production
npm run build

# Test with MCP inspector
npm run inspect
```

## Architecture (for developers)

The MCP server is a **prompt provider**, not an API wrapper:

- `tools.ts` - Defines PMF dimensions, Ralph persona, and prompt templates
- `index.ts` - MCP server that routes tool calls to handlers
- Each handler returns a structured prompt that Claude processes directly

Key exports:
- `PMF_DIMENSIONS` - The 10 scoring dimensions with criteria
- `RALPH_PERSONA` - Ralph's personality and expertise
- `handleBrainstorm/Validate/Refine/PRD/Architecture` - Prompt generators

## License

MIT
