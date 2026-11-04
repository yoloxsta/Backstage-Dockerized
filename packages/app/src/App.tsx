import { createApp } from '@backstage/frontend-defaults';
import catalogPlugin from '@backstage/plugin-catalog/alpha';
import { navModule } from './modules/nav';
import { homeModule } from './modules/home';

export default createApp({
  features: [
    catalogPlugin,
    navModule,
    homeModule,
    // GitHub Actions CI/CD integration
    import('@backstage/plugin-github-actions'),
  ],
});
