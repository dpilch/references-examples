// @ts-check
import { initSchema } from '@aws-amplify/datastore';
import { schema } from './schema';



const { Primary, RelatedMany, RelatedOne } = initSchema(schema);

export {
  Primary,
  RelatedMany,
  RelatedOne
};