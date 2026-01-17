<script lang="ts">
  import { page } from '$app/stores';

  interface Props {
    user?: { email?: string } | null;
  }

  let { user = null }: Props = $props();

  const navItems = [
    { href: '/', label: 'Home', icon: '🏠' },
    { href: '/playground', label: 'Playground', icon: '🎢', protected: true }
  ];

  let mobileMenuOpen = $state(false);
</script>

<nav class="bg-paper border-b-4 border-chalkboard sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-4">
    <div class="flex items-center justify-between h-16">
      <!-- Logo -->
      <a href="/" class="flex items-center gap-2 group">
        <div
          class="w-10 h-10 bg-ralph-yellow rounded-full border-2 border-chalkboard
                 flex items-center justify-center transition-transform group-hover:scale-110"
        >
          <span class="text-xl">🧒</span>
        </div>
        <span class="font-chalk text-xl text-chalkboard hidden sm:block">IdeaRalph</span>
      </a>

      <!-- Desktop Nav -->
      <div class="hidden md:flex items-center gap-6">
        {#each navItems as item}
          {#if !item.protected || user}
            <a
              href={item.href}
              class="flex items-center gap-2 px-3 py-2 rounded-lg font-chalk
                     transition-all duration-200
                     {$page.url.pathname === item.href
                ? 'bg-ralph-yellow/30 text-chalkboard'
                : 'text-chalkboard/70 hover:text-chalkboard hover:bg-ralph-yellow/10'}"
            >
              <span>{item.icon}</span>
              <span>{item.label}</span>
            </a>
          {/if}
        {/each}
      </div>

      <!-- User Section -->
      <div class="flex items-center gap-4">
        {#if user}
          <div class="hidden sm:flex items-center gap-2 text-sm text-chalkboard/70">
            <span class="w-8 h-8 bg-playground-green rounded-full flex items-center justify-center border-2 border-chalkboard">
              {user.email?.[0]?.toUpperCase() || '?'}
            </span>
            <span class="hidden lg:block">{user.email?.split('@')[0]}</span>
          </div>
          <form action="/auth/logout" method="POST">
            <button
              type="submit"
              class="text-sm text-chalkboard/60 hover:text-playground-red transition-colors"
            >
              Logout
            </button>
          </form>
        {:else}
          <a
            href="/auth/login"
            class="btn-crayon text-sm py-2 px-4"
          >
            Sign In
          </a>
        {/if}

        <!-- Mobile Menu Button -->
        <button
          onclick={() => (mobileMenuOpen = !mobileMenuOpen)}
          class="md:hidden p-2 text-chalkboard"
          aria-label="Toggle menu"
        >
          <span class="text-xl">{mobileMenuOpen ? '✕' : '☰'}</span>
        </button>
      </div>
    </div>

    <!-- Mobile Menu -->
    {#if mobileMenuOpen}
      <div class="md:hidden py-4 border-t-2 border-chalkboard/20">
        {#each navItems as item}
          {#if !item.protected || user}
            <a
              href={item.href}
              onclick={() => (mobileMenuOpen = false)}
              class="flex items-center gap-3 px-4 py-3 font-chalk
                     {$page.url.pathname === item.href
                ? 'bg-ralph-yellow/30 text-chalkboard'
                : 'text-chalkboard/70'}"
            >
              <span class="text-xl">{item.icon}</span>
              <span>{item.label}</span>
            </a>
          {/if}
        {/each}
      </div>
    {/if}
  </div>
</nav>
