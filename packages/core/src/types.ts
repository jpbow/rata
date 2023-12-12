import * as React from 'react'
import { type ThemeProviderProps as PackageProps } from 'next-themes/dist/types'

export type { VariantProps } from 'class-variance-authority'

export type ThemeProviderProps = PackageProps & {
    children: React.ReactNode
}

export const themeProviderDefaultProps: PackageProps = {
    attribute: 'class',
    defaultTheme: 'system',
    enableSystem: true,
    disableTransitionOnChange: true,
}
