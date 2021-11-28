import dotenv from 'dotenv';
import { NFTStorage } from 'nft.storage';
import sheldon from  '../metadata/sheldon.mjs'


dotenv.config();
const apiKey = process.env.NFTSTORAGE_API_KEY;

async function main() {

const client = new NFTStorage({ token: apiKey })

const metadata = await client.store(sheldon);

console.log(metadata.url);

}

main();
