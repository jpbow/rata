import type { Config } from 'tailwindcss'
import { tailwindConfig } from '@rata/core'

export default {
    presets: [tailwindConfig],
    content: ['./stories/**/*.{ts,tsx}'],
} satisfies Config
