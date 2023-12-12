import type { Config } from 'tailwindcss'
import { tailwindConfig } from '@rata/core'

export default {
    presets: [tailwindConfig],
    content: [...(tailwindConfig.content as string[]), './stories/**/*.{ts,tsx}'],
} satisfies Config
