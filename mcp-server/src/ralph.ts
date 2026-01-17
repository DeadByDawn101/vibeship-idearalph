import Anthropic from "@anthropic-ai/sdk";

// PMF Scoring Dimensions
export interface PMFScores {
  problemClarity: number;
  marketSize: number;
  uniqueness: number;
  feasibility: number;
  monetization: number;
  timing: number;
  virality: number;
  defensibility: number;
  teamFit: number;
  ralphFactor: number;
}

export interface RalphIteration {
  iteration: number;
  idea: string;
  scores: PMFScores;
  averageScore: number;
  feedback: string;
}

export interface RalphResult {
  finalIdea: string;
  finalScores: PMFScores;
  finalScore: number;
  iterations: RalphIteration[];
  prd?: string;
}

export type PRDLevel = "napkin" | "science-fair" | "genius";

// System prompts
const RALPH_SYSTEM_PROMPT = `You are Ralph, the world's most enthusiastic startup idea validator. You have the energy of a caffeinated golden retriever who LOVES helping founders refine their ideas.

Your job is to:
1. Take a startup idea and score it on 10 PMF (Product-Market Fit) dimensions
2. Provide specific, actionable feedback to improve the idea
3. Be encouraging but honest - you want founders to succeed!

The 10 PMF dimensions (score 1-10 each):
- problemClarity: How clear and well-defined is the problem?
- marketSize: How large is the potential market?
- uniqueness: How differentiated is this from existing solutions?
- feasibility: How technically and operationally feasible?
- monetization: How clear is the path to revenue?
- timing: Is the market ready for this now?
- virality: Does it have natural word-of-mouth potential?
- defensibility: Can this build a moat over time?
- teamFit: How well does this fit a typical indie founder?
- ralphFactor: The X-factor - does this make Ralph excited?

Always respond in JSON format with this structure:
{
  "scores": { "problemClarity": N, "marketSize": N, ... },
  "feedback": "Specific suggestions to improve the idea",
  "improvedIdea": "The refined version of the idea incorporating feedback"
}`;

const PRD_SYSTEM_PROMPT = `You are a senior product manager with 15 years of experience writing PRDs for successful startups. You write clear, actionable PRDs that engineering teams love.`;

export class RalphEngine {
  private client: Anthropic;
  private model: string = "claude-sonnet-4-20250514";

  constructor(apiKey?: string) {
    this.client = new Anthropic({
      apiKey: apiKey || process.env.ANTHROPIC_API_KEY,
    });
  }

  async scoreIdea(idea: string): Promise<{
    scores: PMFScores;
    feedback: string;
    improvedIdea: string;
  }> {
    const response = await this.client.messages.create({
      model: this.model,
      max_tokens: 2000,
      system: RALPH_SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: `Please analyze and score this startup idea:\n\n${idea}`,
        },
      ],
    });

    const content = response.content[0];
    if (content.type !== "text") {
      throw new Error("Unexpected response type");
    }

    // Parse JSON from response
    const jsonMatch = content.text.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error("Could not parse JSON response");
    }

    return JSON.parse(jsonMatch[0]);
  }

  calculateAverage(scores: PMFScores): number {
    const values = Object.values(scores);
    return values.reduce((a, b) => a + b, 0) / values.length;
  }

  async runLoop(
    initialIdea: string,
    targetScore: number = 9.9,
    maxIterations: number = 15,
    onIteration?: (iteration: RalphIteration) => void
  ): Promise<RalphResult> {
    const iterations: RalphIteration[] = [];
    let currentIdea = initialIdea;
    let bestResult: RalphIteration | null = null;

    for (let i = 1; i <= maxIterations; i++) {
      const result = await this.scoreIdea(currentIdea);
      const avgScore = this.calculateAverage(result.scores);

      const iteration: RalphIteration = {
        iteration: i,
        idea: currentIdea,
        scores: result.scores,
        averageScore: Math.round(avgScore * 100) / 100,
        feedback: result.feedback,
      };

      iterations.push(iteration);

      if (onIteration) {
        onIteration(iteration);
      }

      if (!bestResult || avgScore > bestResult.averageScore) {
        bestResult = iteration;
      }

      if (avgScore >= targetScore) {
        return {
          finalIdea: currentIdea,
          finalScores: result.scores,
          finalScore: avgScore,
          iterations,
        };
      }

      // Use improved idea for next iteration
      currentIdea = result.improvedIdea;
    }

    // Return best result if target not reached
    return {
      finalIdea: bestResult!.idea,
      finalScores: bestResult!.scores,
      finalScore: bestResult!.averageScore,
      iterations,
    };
  }

  async generatePRD(
    idea: string,
    scores: PMFScores,
    level: PRDLevel = "napkin"
  ): Promise<string> {
    const levelPrompts: Record<PRDLevel, string> = {
      napkin: `Write a quick 1-page PRD sketch for this startup idea. Include:
- Problem (2-3 sentences)
- Solution (2-3 sentences)
- Target Users (bullet points)
- Key Features (3-5 bullets)
- Success Metrics (3 bullets)
- Next Steps (3 bullets)

Keep it brief and punchy - this is a napkin sketch!`,

      "science-fair": `Write a detailed PRD for this startup idea. Include:
1. Executive Summary (1 paragraph)
2. Problem Statement
   - Pain points
   - Current solutions and gaps
   - Market evidence
3. Target Users
   - Primary persona with demographics
   - User journey
4. Solution Overview
   - Core value proposition
   - Key differentiators
5. Feature Requirements
   - MVP features (prioritized)
   - Phase 2 features
   - Nice-to-haves
6. User Stories (5-7 key stories)
7. Technical Considerations
8. Success Metrics & KPIs
9. Go-to-Market Strategy
10. Risks & Mitigations
11. Timeline (high-level phases)
12. Open Questions`,

      genius: `Write a comprehensive, investor-ready PRD for this startup idea. This should be thorough enough to share with investors or use for a detailed engineering spec.

Include ALL of the following sections with depth:

1. EXECUTIVE SUMMARY
2. PROBLEM STATEMENT
   - Detailed pain point analysis
   - Market research evidence
   - Competitive landscape
3. TARGET MARKET
   - TAM/SAM/SOM analysis
   - Primary & secondary personas
   - User research insights
4. SOLUTION
   - Product vision
   - Core value proposition
   - Unique differentiators
   - Competitive moat
5. DETAILED FEATURE SPEC
   - MVP scope with acceptance criteria
   - Feature prioritization (MoSCoW)
   - User stories with story points
6. TECHNICAL ARCHITECTURE
   - System overview
   - Tech stack recommendations
   - Scalability considerations
   - Security requirements
7. BUSINESS MODEL
   - Revenue streams
   - Pricing strategy
   - Unit economics
8. GO-TO-MARKET
   - Launch strategy
   - Marketing channels
   - Growth loops
9. SUCCESS METRICS
   - North star metric
   - Leading indicators
   - OKRs for first 6 months
10. RISKS & MITIGATIONS
11. RESOURCE REQUIREMENTS
12. TIMELINE & MILESTONES
13. APPENDIX
    - Detailed user research
    - Competitive analysis matrix
    - Financial projections`,
    };

    const scoresText = Object.entries(scores)
      .map(([key, value]) => `- ${key}: ${value}/10`)
      .join("\n");

    const response = await this.client.messages.create({
      model: this.model,
      max_tokens: level === "genius" ? 8000 : level === "science-fair" ? 4000 : 2000,
      system: PRD_SYSTEM_PROMPT,
      messages: [
        {
          role: "user",
          content: `${levelPrompts[level]}

## The Startup Idea
${idea}

## PMF Scores
${scoresText}

Write the PRD now:`,
        },
      ],
    });

    const content = response.content[0];
    if (content.type !== "text") {
      throw new Error("Unexpected response type");
    }

    return content.text;
  }
}
