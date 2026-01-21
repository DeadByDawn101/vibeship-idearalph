<script lang="ts">
  import { onMount } from 'svelte';

  // Countdown state
  let days = $state(0);
  let hours = $state(0);
  let minutes = $state(0);
  let seconds = $state(0);

  // Set hackathon end date (2 weeks from now - adjust as needed)
  const endDate = new Date();
  endDate.setDate(endDate.getDate() + 14);

  // Stats (will be dynamic later)
  let builders = $state(0);
  let projects = $state(0);

  // Copy state
  let copied = $state(false);

  // FAQ state
  let openFaq = $state<number | null>(null);

  const faqs = [
    {
      q: "What is vibe coding?",
      a: "Building apps with AI assistance (Claude Code, Cursor, Copilot). You don't need to be a senior dev - if you can ship with AI, you're a vibe coder."
    },
    {
      q: "How does the launchpad work?",
      a: "Build your app → Create hype on X → Get users → List on vibe/vibe to raise. Two paths: Community Launch (open to all) or Seedify Curated (higher raises for top projects)."
    },
    {
      q: "Is there a deadline?",
      a: "No! This is a continuous hackathon. Build at your pace. Raise when you're ready. No waiting for results."
    },
    {
      q: "Can existing projects join?",
      a: "Yes! If you already have a vibe-coded app with traction, you can list on vibe/vibe when it launches."
    },
    {
      q: "How do I get $RALPH tokens?",
      a: "Multiple ways: participate in the hackathon, launch on vibe/vibe, get strong usage metrics, or get selected for Seedify curation."
    },
    {
      q: "What's the difference between Community and Curated?",
      a: "Community Launch is open to everyone who ships. Seedify Curated is for projects with exceptional traction - they get higher raise caps and bonus token allocations."
    },
    {
      q: "Do I need to pay anything?",
      a: "No. The MCP is free. Claude Code has a free tier. Everything runs locally. The launchpad will have standard Seedify terms."
    }
  ];

  function updateCountdown() {
    const now = new Date().getTime();
    const distance = endDate.getTime() - now;

    if (distance > 0) {
      days = Math.floor(distance / (1000 * 60 * 60 * 24));
      hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      seconds = Math.floor((distance % (1000 * 60)) / 1000);
    }
  }

  function copyCommand() {
    const command = 'git clone https://github.com/vibeforge1111/vibeship-idearalph.git ~/idearalph && cd ~/idearalph/mcp-server && npm i && npm run build && claude mcp add idearalph -- node ~/idearalph/mcp-server/dist/index.js';
    navigator.clipboard.writeText(command);
    copied = true;
    setTimeout(() => copied = false, 2000);
  }

  function toggleFaq(index: number) {
    openFaq = openFaq === index ? null : index;
  }

  onMount(() => {
    updateCountdown();
    const interval = setInterval(updateCountdown, 1000);
    return () => clearInterval(interval);
  });
</script>

<svelte:head>
  <title>Vibecode: Build → Hype → Raise | IdeaRalph x Seedify</title>
  <meta name="description" content="The first launchpad for vibe-coded apps. Build with AI, create hype on X, raise on vibe/vibe. If you can ship, you're eligible." />
</svelte:head>

<main class="bg-playground-sunset overflow-hidden">
  <!-- Hero Section with Video Background -->
  <section class="relative min-h-screen flex items-center justify-center px-4 py-16 overflow-hidden">
    <!-- Video Background -->
    <div class="absolute inset-0 z-0">
      <video
        autoplay
        loop
        muted
        playsinline
        preload="auto"
        disablepictureinpicture
        class="w-full h-full object-cover"
      >
        <source src="/videos/hackathon-hero.mp4" type="video/mp4" />
      </video>
      <!-- Gradient overlay for readability -->
      <div class="absolute inset-0 bg-gradient-to-b from-chalkboard/60 via-chalkboard/40 to-chalkboard/70"></div>
    </div>

    <!-- Content -->
    <div class="relative z-10 max-w-4xl mx-auto text-center">
      <!-- Logos -->
      <div class="flex items-center justify-center gap-4 mb-8">
        <div class="flex items-center gap-2 bg-white/90 px-4 py-2 rounded-xl border-3 border-chalkboard shadow-crayon">
          <img src="/images/ralph-logo.png" alt="IdeaRalph" class="w-8 h-8 rounded-full" />
          <span class="font-chalk text-chalkboard">IdeaRalph</span>
        </div>
        <span class="text-2xl text-white">×</span>
        <div class="flex items-center gap-2 bg-white/90 px-4 py-2 rounded-xl border-3 border-chalkboard shadow-crayon">
          <span class="font-chalk text-chalkboard">Seedify</span>
        </div>
      </div>

      <!-- Title -->
      <h1 class="font-chalk text-5xl md:text-7xl lg:text-8xl text-white mb-4 leading-tight drop-shadow-lg">
        VIBECODE
      </h1>
      <p class="font-chalk text-2xl md:text-3xl text-ralph-yellow mb-6 drop-shadow-md">
        Build → Hype → Raise
      </p>

      <!-- Tagline -->
      <p class="text-xl md:text-2xl text-white/90 mb-4 max-w-2xl mx-auto drop-shadow">
        The first launchpad for <span class="font-bold text-ralph-yellow">vibe-coded</span> apps.
      </p>
      <p class="text-lg text-white/70 mb-10 max-w-xl mx-auto drop-shadow">
        If you can ship, you're eligible. No gatekeeping.
      </p>

      <!-- Countdown -->
      <div class="flex items-center justify-center gap-3 md:gap-4 mb-10">
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-4 py-3 md:px-6 md:py-4 min-w-[70px] md:min-w-[90px]">
          <div class="font-chalk text-3xl md:text-4xl text-chalkboard">{days}</div>
          <div class="text-xs md:text-sm text-chalkboard/60">days</div>
        </div>
        <span class="font-chalk text-2xl text-chalkboard/40">:</span>
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-4 py-3 md:px-6 md:py-4 min-w-[70px] md:min-w-[90px]">
          <div class="font-chalk text-3xl md:text-4xl text-chalkboard">{hours.toString().padStart(2, '0')}</div>
          <div class="text-xs md:text-sm text-chalkboard/60">hours</div>
        </div>
        <span class="font-chalk text-2xl text-chalkboard/40">:</span>
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-4 py-3 md:px-6 md:py-4 min-w-[70px] md:min-w-[90px]">
          <div class="font-chalk text-3xl md:text-4xl text-chalkboard">{minutes.toString().padStart(2, '0')}</div>
          <div class="text-xs md:text-sm text-chalkboard/60">mins</div>
        </div>
        <span class="font-chalk text-2xl text-chalkboard/40">:</span>
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-4 py-3 md:px-6 md:py-4 min-w-[70px] md:min-w-[90px]">
          <div class="font-chalk text-3xl md:text-4xl text-chalkboard">{seconds.toString().padStart(2, '0')}</div>
          <div class="text-xs md:text-sm text-chalkboard/60">secs</div>
        </div>
      </div>

      <!-- Stats -->
      <div class="flex items-center justify-center gap-4 md:gap-6 mb-10">
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-5 py-3">
          <div class="font-chalk text-2xl text-playground-green">15%</div>
          <div class="text-xs text-chalkboard/70">$RALPH Prize Pool</div>
        </div>
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-5 py-3">
          <div class="font-chalk text-2xl text-chalkboard">{builders}</div>
          <div class="text-xs text-chalkboard/70">Builders</div>
        </div>
        <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon px-5 py-3">
          <div class="font-chalk text-2xl text-chalkboard">{projects}</div>
          <div class="text-xs text-chalkboard/70">Projects</div>
        </div>
      </div>

      <!-- CTA -->
      <a href="#how-to-enter" class="btn-crayon text-xl px-10 py-5 inline-flex items-center gap-3 animate-pulse-subtle">
        <span>Start Building Now</span>
        <span class="text-2xl">🛠️</span>
      </a>
    </div>
  </section>

  <!-- The Flow Section -->
  <section class="bg-paper py-16 md:py-24 px-4">
    <div class="max-w-4xl mx-auto">
      <!-- Quote -->
      <div class="flex justify-center mb-10">
        <div class="thought-bubble bg-white px-8 py-4">
          <p class="ralph-voice text-xl md:text-2xl text-chalkboard text-center">
            "90% of hackathon projects die after demo day. Not anymore."
          </p>
        </div>
      </div>

      <!-- 4 Step Flow: Build → Hype → Usage → Raise -->
      <div class="flex flex-col md:flex-row items-center justify-center gap-6 md:gap-8 mb-10">
        <div class="flex flex-col items-center text-center">
          <div class="w-16 h-16 bg-ralph-yellow rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-2">
            <span class="text-2xl">🛠️</span>
          </div>
          <span class="font-chalk text-lg">Build</span>
          <span class="text-xs text-chalkboard/60">Vibe code your app</span>
        </div>
        <span class="text-2xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-2xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-16 h-16 bg-playground-green rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-2">
            <span class="text-2xl">📣</span>
          </div>
          <span class="font-chalk text-lg">Hype</span>
          <span class="text-xs text-chalkboard/60">Create buzz on X</span>
        </div>
        <span class="text-2xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-2xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-16 h-16 bg-sky-blue rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-2">
            <span class="text-2xl">📊</span>
          </div>
          <span class="font-chalk text-lg">Usage</span>
          <span class="text-xs text-chalkboard/60">Get people using it</span>
        </div>
        <span class="text-2xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-2xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-16 h-16 bg-purple-400 rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-2">
            <span class="text-2xl">💰</span>
          </div>
          <span class="font-chalk text-lg">Raise</span>
          <span class="text-xs text-chalkboard/60">Launch on vibe/vibe</span>
        </div>
      </div>

      <!-- Description -->
      <p class="text-center text-chalkboard/70 text-lg max-w-2xl mx-auto mb-6">
        Build with AI (Claude Code, Cursor, Copilot). Create traction on X. Raise on <span class="font-bold">vibe/vibe</span> launchpad.
      </p>
      <p class="text-center text-chalkboard font-bold text-xl">
        No deadline. No limits. If you ship, you can raise.
      </p>
    </div>
  </section>

  <!-- vibe/vibe Launchpad Teaser -->
  <section class="bg-gradient-to-b from-purple-500 to-purple-700 py-16 md:py-20 px-4">
    <div class="max-w-4xl mx-auto text-center">
      <div class="inline-block bg-white/20 backdrop-blur-sm px-4 py-2 rounded-full mb-6">
        <span class="text-white font-bold text-sm">🚀 COMING IN DAYS</span>
      </div>

      <h2 class="font-chalk text-4xl md:text-5xl text-white mb-4">
        vibe/vibe Launchpad
      </h2>
      <p class="text-xl text-white/80 mb-8 max-w-xl mx-auto">
        The first launchpad built for vibe coders. Powered by Seedify.
      </p>

      <!-- Two Paths -->
      <div class="grid md:grid-cols-2 gap-6 max-w-2xl mx-auto mb-8">
        <div class="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
          <div class="text-3xl mb-3">🌐</div>
          <h3 class="font-chalk text-xl text-white mb-2">Community Launch</h3>
          <p class="text-white/70 text-sm mb-3">Ship an app + have X traction</p>
          <div class="text-white/50 text-xs">Open to everyone who builds</div>
        </div>

        <div class="bg-ralph-yellow/20 backdrop-blur-sm rounded-xl p-6 border border-ralph-yellow/40">
          <div class="text-3xl mb-3">👑</div>
          <h3 class="font-chalk text-xl text-ralph-yellow mb-2">Seedify Curated</h3>
          <p class="text-white/70 text-sm mb-3">Strong traction → higher raise</p>
          <div class="text-ralph-yellow/70 text-xs">+ Bonus $RALPH allocation</div>
        </div>
      </div>

      <p class="text-white/60 text-sm max-w-lg mx-auto">
        Start building NOW. The launchpad drops soon. A significant portion of <span class="text-ralph-yellow font-bold">$RALPH</span> tokens goes to projects that launch on vibe/vibe.
      </p>
    </div>
  </section>

  <!-- Prize Categories Section -->
  <section class="bg-chalkboard py-16 md:py-24 px-4">
    <div class="max-w-5xl mx-auto">
      <h2 class="font-chalk text-3xl md:text-4xl text-ralph-yellow text-center mb-4">
        🏆 Earn $RALPH Tokens
      </h2>
      <p class="text-center text-white/60 mb-12">Multiple ways to earn while you build</p>

      <!-- Category Grid -->
      <div class="grid md:grid-cols-2 gap-6 mb-8">
        <!-- Stupid Smart -->
        <div class="bg-paper rounded-xl p-6 border-3 border-chalkboard shadow-crayon transition-transform hover:rotate-1 hover:-translate-y-1">
          <div class="text-3xl mb-3">🤪</div>
          <h3 class="font-chalk text-xl text-chalkboard mb-2">Stupid Smart</h3>
          <p class="text-chalkboard/70 text-sm mb-4">Most Ralph energy. Sounds dumb at first, but is actually genius.</p>
          <div class="inline-block bg-ralph-yellow/30 px-3 py-1 rounded-lg">
            <span class="font-bold text-chalkboard text-sm">8% of pool</span>
          </div>
        </div>

        <!-- Speed Run -->
        <div class="bg-paper rounded-xl p-6 border-3 border-chalkboard shadow-crayon transition-transform hover:-rotate-1 hover:-translate-y-1">
          <div class="text-3xl mb-3">⚡</div>
          <h3 class="font-chalk text-xl text-chalkboard mb-2">Speed Run</h3>
          <p class="text-chalkboard/70 text-sm mb-4">Fastest from idea to deployed product. Show your velocity.</p>
          <div class="inline-block bg-sky-blue/30 px-3 py-1 rounded-lg">
            <span class="font-bold text-chalkboard text-sm">8% of pool</span>
          </div>
        </div>

        <!-- Loop Master -->
        <div class="bg-paper rounded-xl p-6 border-3 border-chalkboard shadow-crayon transition-transform hover:rotate-1 hover:-translate-y-1">
          <div class="text-3xl mb-3">🔄</div>
          <h3 class="font-chalk text-xl text-chalkboard mb-2">Loop Master</h3>
          <p class="text-chalkboard/70 text-sm mb-4">Highest PMF score achieved. Show the iteration journey.</p>
          <div class="inline-block bg-playground-green/30 px-3 py-1 rounded-lg">
            <span class="font-bold text-chalkboard text-sm">8% of pool</span>
          </div>
        </div>

        <!-- Vibe Ship -->
        <div class="bg-paper rounded-xl p-6 border-3 border-chalkboard shadow-crayon transition-transform hover:-rotate-1 hover:-translate-y-1">
          <div class="text-3xl mb-3">🚀</div>
          <h3 class="font-chalk text-xl text-chalkboard mb-2">Vibe Ship</h3>
          <p class="text-chalkboard/70 text-sm mb-4">Best use of SvelteKit + Supabase + Spawner stack.</p>
          <div class="inline-block bg-purple-300/50 px-3 py-1 rounded-lg">
            <span class="font-bold text-chalkboard text-sm">8% of pool</span>
          </div>
        </div>
      </div>

      <!-- Community Choice - Full Width -->
      <div class="bg-paper rounded-xl p-6 border-3 border-chalkboard shadow-crayon mb-8 transition-transform hover:rotate-1 hover:-translate-y-1">
        <div class="flex items-center gap-4">
          <div class="text-4xl">❤️</div>
          <div class="flex-1">
            <h3 class="font-chalk text-xl text-chalkboard mb-1">Community Choice</h3>
            <p class="text-chalkboard/70 text-sm">Most voted by the community. Build something people love to share.</p>
          </div>
          <div class="bg-playground-sunset/30 px-4 py-2 rounded-lg">
            <span class="font-bold text-chalkboard">8% of pool</span>
          </div>
        </div>
      </div>

      <!-- Grand Prize -->
      <div class="bg-ralph-yellow rounded-xl p-8 border-4 border-chalkboard shadow-crayon-lg text-center">
        <div class="text-5xl mb-4">👑</div>
        <h3 class="font-chalk text-2xl md:text-3xl text-chalkboard mb-2">Grand Prize</h3>
        <p class="text-chalkboard/70 mb-4">Best overall project across all dimensions</p>
        <div class="inline-block bg-white px-6 py-3 rounded-xl border-2 border-chalkboard">
          <span class="font-chalk text-2xl text-chalkboard">20% of prize pool</span>
        </div>
      </div>
    </div>
  </section>

  <!-- The Ralph Loop Section -->
  <section class="bg-white py-16 md:py-24 px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="font-chalk text-3xl md:text-4xl text-chalkboard text-center mb-4">
        🔄 The Ralph Loop
      </h2>
      <p class="text-center text-chalkboard/60 mb-12 max-w-xl mx-auto">
        Ralph iterates on your idea until it scores 9.5+ on 10 PMF dimensions. Then guides you to launch.
      </p>

      <!-- Flow Visualization -->
      <div class="bg-paper rounded-2xl border-3 border-chalkboard shadow-crayon p-8 mb-8">
        <!-- Top Row: Brainstorm → Validate → Iterate (with loop) -->
        <div class="flex flex-wrap items-center justify-center gap-3 mb-6">
          <span class="bg-ralph-yellow px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Brainstorm</span>
          <span class="text-chalkboard">→</span>
          <span class="bg-ralph-yellow/70 px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Validate</span>
          <span class="text-chalkboard">→</span>
          <div class="flex items-center gap-2">
            <span class="bg-playground-green px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Iterate</span>
            <span class="text-xs text-chalkboard/60">↺ until 9.5+</span>
          </div>
        </div>

        <!-- Arrow down -->
        <div class="text-center text-2xl text-chalkboard/40 mb-6">↓</div>

        <!-- Bottom Row: PRD → Design → Architecture → Checklist → Ship -->
        <div class="flex flex-wrap items-center justify-center gap-3">
          <span class="bg-sky-blue/70 px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">PRD</span>
          <span class="text-chalkboard">→</span>
          <span class="bg-purple-300 px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Design</span>
          <span class="text-chalkboard">→</span>
          <span class="bg-orange-300 px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Architecture</span>
          <span class="text-chalkboard">→</span>
          <span class="bg-playground-green px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">Checklist</span>
          <span class="text-chalkboard">→</span>
          <span class="bg-chalkboard text-white px-4 py-2 rounded-lg text-sm font-bold border-2 border-chalkboard">🚀 Ship!</span>
        </div>
      </div>

      <!-- PMF Dimensions -->
      <div class="text-center">
        <p class="text-sm text-chalkboard/60 mb-3">Scored on 10 PMF dimensions:</p>
        <div class="flex flex-wrap justify-center gap-2">
          {#each ['Problem', 'Market', 'Unique', 'Feasible', 'Revenue', 'Timing', 'Viral', 'Moat', 'Team Fit', 'Ralph Factor'] as dim}
            <span class="bg-chalkboard/10 px-2 py-1 rounded text-xs text-chalkboard/70">{dim}</span>
          {/each}
        </div>
      </div>
    </div>
  </section>

  <!-- Tokenomics Section -->
  <section class="bg-paper py-16 md:py-24 px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="font-chalk text-3xl md:text-4xl text-chalkboard text-center mb-4">
        💰 $RALPH Tokenomics
      </h2>
      <p class="text-center text-chalkboard/60 mb-10">
        No team allocation. Fair launch.
      </p>

      <!-- Token Bar -->
      <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon p-6 mb-8">
        <div class="flex h-12 rounded-lg overflow-hidden border-2 border-chalkboard">
          <div class="bg-sky-blue flex items-center justify-center text-white text-xs font-bold" style="width: 35%">
            Seedify 35%
          </div>
          <div class="bg-playground-green flex items-center justify-center text-white text-xs font-bold" style="width: 40%">
            Community 40%
          </div>
          <div class="bg-ralph-yellow flex items-center justify-center text-chalkboard text-xs font-bold" style="width: 15%">
            Hack 15%
          </div>
          <div class="bg-purple-400 flex items-center justify-center text-white text-xs font-bold" style="width: 10%">
            Liq 10%
          </div>
        </div>
      </div>

      <!-- Token Cards -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div class="bg-sky-blue/20 rounded-xl p-4 border-2 border-chalkboard/20 text-center">
          <div class="font-chalk text-2xl text-chalkboard">35%</div>
          <div class="text-sm text-chalkboard/70">Seedify</div>
        </div>
        <div class="bg-playground-green/20 rounded-xl p-4 border-2 border-chalkboard/20 text-center">
          <div class="font-chalk text-2xl text-chalkboard">40%</div>
          <div class="text-sm text-chalkboard/70">Community (X)</div>
        </div>
        <div class="bg-ralph-yellow/30 rounded-xl p-4 border-2 border-chalkboard/20 text-center">
          <div class="font-chalk text-2xl text-chalkboard">15%</div>
          <div class="text-sm text-chalkboard/70">Hackathon</div>
        </div>
        <div class="bg-purple-300/30 rounded-xl p-4 border-2 border-chalkboard/20 text-center">
          <div class="font-chalk text-2xl text-chalkboard">10%</div>
          <div class="text-sm text-chalkboard/70">Liquidity</div>
        </div>
      </div>
    </div>
  </section>

  <!-- How to Enter Section -->
  <section id="how-to-enter" class="bg-gradient-to-b from-playground-green/20 to-white py-16 md:py-24 px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="font-chalk text-3xl md:text-4xl text-chalkboard text-center mb-4">
        🚀 Start Building Now
      </h2>
      <p class="text-center text-chalkboard/60 mb-12">Get ready for the vibe/vibe launchpad</p>

      <!-- 4 Steps -->
      <div class="flex flex-col md:flex-row items-center justify-center gap-6 mb-12">
        <div class="flex flex-col items-center text-center">
          <div class="w-14 h-14 bg-ralph-yellow rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-3">
            <span class="font-chalk text-xl">1</span>
          </div>
          <span class="font-chalk text-lg text-chalkboard">Install MCP</span>
          <span class="text-sm text-chalkboard/60">Get Ralph powers</span>
        </div>
        <span class="text-3xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-3xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-14 h-14 bg-playground-green rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-3">
            <span class="font-chalk text-xl text-white">2</span>
          </div>
          <span class="font-chalk text-lg text-chalkboard">Build Your App</span>
          <span class="text-sm text-chalkboard/60">Vibe code it</span>
        </div>
        <span class="text-3xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-3xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-14 h-14 bg-sky-blue rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-3">
            <span class="font-chalk text-xl text-white">3</span>
          </div>
          <span class="font-chalk text-lg text-chalkboard">Hype on X</span>
          <span class="text-sm text-chalkboard/60">Build traction</span>
        </div>
        <span class="text-3xl text-chalkboard/30 hidden md:block">→</span>
        <span class="text-3xl text-chalkboard/30 md:hidden rotate-90">→</span>
        <div class="flex flex-col items-center text-center">
          <div class="w-14 h-14 bg-purple-400 rounded-full flex items-center justify-center border-3 border-chalkboard shadow-crayon mb-3">
            <span class="font-chalk text-xl text-white">4</span>
          </div>
          <span class="font-chalk text-lg text-chalkboard">Raise</span>
          <span class="text-sm text-chalkboard/60">On vibe/vibe</span>
        </div>
      </div>

      <!-- Install Command -->
      <div class="bg-white rounded-xl border-3 border-chalkboard shadow-crayon p-6 max-w-2xl mx-auto mb-8">
        <p class="text-sm text-chalkboard/70 mb-3">Install command:</p>
        <div class="bg-chalkboard rounded-lg p-4 mb-4">
          <code class="text-xs text-playground-green font-mono break-all leading-relaxed block">
            git clone https://github.com/vibeforge1111/vibeship-idearalph.git ~/idearalph && cd ~/idearalph/mcp-server && npm i && npm run build && claude mcp add idearalph -- node ~/idearalph/mcp-server/dist/index.js
          </code>
        </div>
        <button
          onclick={copyCommand}
          class="btn-crayon w-full text-sm {copied ? 'bg-playground-green' : ''}"
        >
          {copied ? '✓ Copied!' : 'Copy Command'}
        </button>
      </div>

      <!-- Restart Note -->
      <p class="text-center text-chalkboard/60 text-sm">
        Then restart Claude: <code class="bg-chalkboard/10 px-2 py-1 rounded">/exit</code> → <code class="bg-chalkboard/10 px-2 py-1 rounded">claude</code>
      </p>
    </div>
  </section>

  <!-- FAQ Section -->
  <section class="bg-white py-16 md:py-24 px-4">
    <div class="max-w-2xl mx-auto">
      <h2 class="font-chalk text-3xl md:text-4xl text-chalkboard text-center mb-12">
        ❓ FAQ
      </h2>

      <div class="space-y-4">
        {#each faqs as faq, i}
          <div class="border-2 border-chalkboard/20 rounded-xl overflow-hidden">
            <button
              onclick={() => toggleFaq(i)}
              class="w-full px-6 py-4 text-left flex items-center justify-between bg-paper hover:bg-ralph-yellow/10 transition-colors"
            >
              <span class="font-bold text-chalkboard">{faq.q}</span>
              <span class="text-chalkboard/60 text-xl">{openFaq === i ? '−' : '+'}</span>
            </button>
            {#if openFaq === i}
              <div class="px-6 py-4 bg-white border-t border-chalkboard/10">
                <p class="text-chalkboard/70">{faq.a}</p>
              </div>
            {/if}
          </div>
        {/each}
      </div>
    </div>
  </section>

  <!-- Final CTA Section -->
  <section class="bg-chalkboard py-16 md:py-24 px-4">
    <div class="max-w-3xl mx-auto text-center">
      <p class="text-white/80 text-lg md:text-xl mb-6 italic">
        "The future of startups is one person with Claude Code, an idea that sounds stupid, and the audacity to ship and raise."
      </p>

      <div class="flex flex-col sm:flex-row items-center justify-center gap-4 mb-8">
        <a href="#how-to-enter" class="btn-crayon text-lg px-8 py-3">
          🛠️ Start Building Now
        </a>
        <a href="/docs/MANIFESTO.md" class="text-white/70 hover:text-white underline">
          Read the Manifesto →
        </a>
      </div>

      <!-- Launchpad coming soon reminder -->
      <div class="bg-purple-500/20 border border-purple-400/30 rounded-xl p-4 mb-8 max-w-md mx-auto">
        <p class="text-purple-300 text-sm">
          <span class="font-bold">vibe/vibe launchpad</span> drops in days. Build now, raise soon.
        </p>
      </div>

      <!-- Vibeship Branding -->
      <div class="flex items-center justify-center gap-2 text-white/50">
        <span class="text-sm">Powered by</span>
        <a href="https://vibeship.co" target="_blank" rel="noopener noreferrer" class="flex items-center gap-1 hover:text-white/70 transition-colors">
          <img
            src="https://raw.githubusercontent.com/vibeforge1111/vibeship-spawner/main/web/static/logo.png"
            alt="Vibeship"
            class="w-5 h-5 opacity-60"
            style="filter: grayscale(100%) brightness(2);"
          />
          <span class="font-semibold">vibeship</span>
        </a>
      </div>
    </div>
  </section>
</main>

<style>
  @keyframes pulse-subtle {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.02); }
  }

  .animate-pulse-subtle {
    animation: pulse-subtle 2s ease-in-out infinite;
  }
</style>
