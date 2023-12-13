import { mount } from 'enzyme'
import { create, act, ReactTestRenderer } from 'react-test-renderer'
import { Button } from '../'

it('should render the button with default props', () => {
    const instance = create(<Button>Click me</Button>).root

    const bars = instance.findAllByType(BarItem)
    expect(bars).toHaveLength(3)
    bars.forEach((bar, index) => {
        expect(bar.findByType('text').children[0]).toBe(`${index + 1}0`)
    })
})
