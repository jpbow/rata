import type { ThemeProviderProps } from './types'
import type { ReactNode } from 'react'
import { ThemeProvider } from './ThemeProvider'

type AllProps = {
    children: ReactNode
    themeProvider?: ThemeProviderProps
}

export const AllProviders: React.FC<AllProps> = ({ children, themeProvider }) => {
    return <ThemeProvider {...themeProvider}>{children}</ThemeProvider>
}
