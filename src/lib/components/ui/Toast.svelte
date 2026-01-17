<script lang="ts">
  interface Props {
    message: string;
    type?: 'success' | 'error' | 'info';
    visible?: boolean;
    onclose?: () => void;
  }

  let { message, type = 'info', visible = true, onclose }: Props = $props();

  const typeStyles = {
    success: {
      bg: 'bg-playground-green/90',
      border: 'border-playground-green',
      icon: '✅'
    },
    error: {
      bg: 'bg-playground-red/90',
      border: 'border-playground-red',
      icon: '❌'
    },
    info: {
      bg: 'bg-sky-blue/90',
      border: 'border-sky-blue',
      icon: '💡'
    }
  };

  const style = typeStyles[type];

  // Auto-dismiss after 4 seconds
  $effect(() => {
    if (visible && onclose) {
      const timer = setTimeout(() => {
        onclose();
      }, 4000);
      return () => clearTimeout(timer);
    }
  });
</script>

{#if visible}
  <div
    class="fixed bottom-4 right-4 z-50 animate-slide-up"
    role="alert"
  >
    <div
      class="{style.bg} {style.border} border-2 rounded-lg shadow-crayon-lg
             px-4 py-3 flex items-center gap-3 max-w-sm"
    >
      <span class="text-xl">{style.icon}</span>
      <p class="text-white font-medium flex-1">{message}</p>
      {#if onclose}
        <button
          onclick={onclose}
          class="text-white/80 hover:text-white text-xl"
          aria-label="Close"
        >
          ✕
        </button>
      {/if}
    </div>
  </div>
{/if}

<style>
  @keyframes slide-up {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .animate-slide-up {
    animation: slide-up 0.3s ease-out;
  }
</style>
