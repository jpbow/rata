import type { Meta, StoryObj } from '@storybook/react'
import { Button } from '@rata/button'

const meta: Meta<typeof Button> = {
    title: 'Button',
    component: Button,
    tags: ['autodocs'],
}

export default meta
type Story = StoryObj<typeof Button>

export const Default: Story = {
    render: () => <div className="bg-black">Click me!!</div>,
}
