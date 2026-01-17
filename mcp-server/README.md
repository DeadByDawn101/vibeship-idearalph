# IdeaRalph MCP Server

AI-powered startup idea generation, validation, and refinement using Claude.

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
- An Anthropic API key

### Build the Server

```bash
cd mcp-server
npm install
npm run build
```

### Configure Claude Code

Add to your Claude Code MCP settings (`~/.config/claude-code/mcp.json` on Mac/Linux or `%APPDATA%\claude-code\mcp.json` on Windows):

```json
{
  "mcpServers": {
    "idearalph": {
      "command": "node",
      "args": ["C:/Users/USER/Desktop/vibeship-idearalph/mcp-server/dist/index.js"],
      "env": {
        "ANTHROPIC_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

**Important**: Replace the path with your actual installation path.

### Alternative: Use npx (after publishing)

```json
{
  "mcpServers": {
    "idearalph": {
      "command": "npx",
      "args": ["idearalph-mcp"],
      "env": {
        "ANTHROPIC_API_KEY": "your-api-key-here"
      }
    }
  }
}
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

1. **Problem Clarity** - How clear and well-defined is the problem?
2. **Market Size** - How large is the potential market?
3. **Uniqueness** - How differentiated from existing solutions?
4. **Feasibility** - How technically and operationally feasible?
5. **Monetization** - How clear is the path to revenue?
6. **Timing** - Is the market ready for this now?
7. **Virality** - Does it have natural word-of-mouth potential?
8. **Defensibility** - Can this build a moat over time?
9. **Team Fit** - How well does this fit an indie founder?
10. **Ralph Factor** - The X-factor excitement score!

## PRD Levels

- **Napkin**: Quick 1-page sketch (5 min read)
- **Science Fair**: Detailed with personas, user stories (15 min read)
- **Genius**: Investor-ready with TAM/SAM/SOM, business model (30+ min read)

## Refinement Modes

- **single**: One round of feedback and improvement
- **target**: Keep iterating until target score reached (default: 9.5)
- **max**: Run all iterations for maximum polish

## Integration with Spawner

After generating a PRD, use `idearalph_architecture` to get:
- Recommended tech stack
- Spawner skills to invoke for each phase
- Implementation timeline

Then use Spawner skills to build:
```
spawner_load({ skill_id: "sveltekit", context: "Building [your idea]..." })
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

## License

MIT
