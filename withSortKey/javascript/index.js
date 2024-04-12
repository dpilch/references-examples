// @ts-check
import { initSchema } from '@aws-amplify/datastore';
import { schema } from './schema';



const { Primary, Related } = initSchema(schema);

export {
  Primary,
  Related
};