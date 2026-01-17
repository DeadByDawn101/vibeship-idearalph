<script lang="ts">
  import { page } from '$app/stores';

  interface Props {
    user?: { email?: string } | null;
  }

  let { user = null }: Props = $props();

  let mobileMenuOpen = $state(false);
</script>

<nav class="bg-paper border-b-4 border-chalkboard sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-4">
    <div class="flex items-center justify-between h-16">
      <!-- Logo with Ralph's head -->
      <a href="/" class="flex items-center gap-2 group">
        <div
          class="w-10 h-10 bg-ralph-yellow rounded-full border-2 border-chalkboard overflow-hidden
                 flex items-center justify-center transition-transform group-hover:scale-110"
        >
          <span class="text-xl">🧒</span>
        </div>
        <span class="font-chalk text-xl text-chalkboard hidden sm:block">IdeaRalph</span>
      </a>

      <!-- Spacer -->
      <div class="flex-1"></div>

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

      </div>
    </div>
  </div>
</nav>
