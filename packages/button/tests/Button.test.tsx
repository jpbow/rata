import { mount } from "enzyme";
import { act, create, ReactTestRenderer } from "react-test-renderer";

import { Button } from "../";

it.skip("should render the button with default props", () => {
  const instance = create(<Button>Click me</Button>).root;

  expect(instance).toBeDefined();
});
