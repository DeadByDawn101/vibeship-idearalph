<script lang="ts">
  import { RALPH_QUOTES } from '$lib/ralph/types';

  interface Props {
    size?: 'sm' | 'md' | 'lg';
    message?: string;
    showQuote?: boolean;
  }

  let { size = 'md', message = 'Loading...', showQuote = true }: Props = $props();

  const sizeClasses = {
    sm: 'w-8 h-8 text-2xl',
    md: 'w-16 h-16 text-4xl',
    lg: 'w-24 h-24 text-6xl'
  };

  const quotes = RALPH_QUOTES.thinking;
  const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
</script>

<div class="flex flex-col items-center justify-center gap-4">
  <!-- Spinning Ralph -->
  <div
    class="{sizeClasses[size]} bg-ralph-yellow rounded-full border-4 border-chalkboard
           flex items-center justify-center animate-bounce shadow-crayon"
  >
    <span class="animate-spin-slow">🧒</span>
  </div>

  <!-- Message -->
  <p class="font-chalk text-chalkboard">{message}</p>

  <!-- Random Quote -->
  {#if showQuote}
    <p class="ralph-voice text-chalkboard/60 text-sm text-center max-w-xs">
      "{randomQuote}"
    </p>
  {/if}
</div>

<style>
  @keyframes spin-slow {
    0% {
      transform: rotate(0deg);
    }
    25% {
      transform: rotate(15deg);
    }
    75% {
      transform: rotate(-15deg);
    }
    100% {
      transform: rotate(0deg);
    }
  }

  .animate-spin-slow {
    animation: spin-slow 1s ease-in-out infinite;
  }
</style>
