import fs from "fs";
import { File } from "nft.storage";

const sheldon = {
  name: "Sheldon",
  description:
    "inflated ego, social ineptitude, and an inability to relate emotionally with other people",
  image: new File(
    [await fs.promises.readFile("images/shelly.jpeg")],
    "shelly.jpeg",
    { type: "image/jpeg" }
  ),
  attributes: [
    {
      name: "Sheldon",
      description: "",
      image: "",
      attributes: [
        {
          name: "Sheldon",
          description: "",
          image: "",
          attributes: [
            {
              name: "Sheldon",
              description: "",
              image: "",
              attributes: [
                { trait_type: "emphatic", value: 28 },
                { trait_type: "toleration", value: 85 },
                { trait_type: "Nerdy", value: 77 },
                { trait_type: "SocialSkills", value: 84 },
                { trait_type: "Extrovert", value: 77 },
                { trait_type: "organized", value: 44 },
              ],
            },
          ],
        },
      ],
    },
  ],
};

export default sheldon;
