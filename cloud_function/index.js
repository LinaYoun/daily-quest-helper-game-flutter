import { GoogleGenAI, Modality } from "@google/genai";
import functions from "@google-cloud/functions-framework";

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
  console.warn("GEMINI_API_KEY is not set. The function will fail until provided.");
}

const genAI = new GoogleGenAI({ apiKey });

functions.http("generateIcon", async (req, res) => {
  res.set("Access-Control-Allow-Origin", req.headers.origin || "*");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
  if (req.method === "OPTIONS") return res.status(204).send("");

  try {
    const { prompt, referenceDataUrl } = req.body || {};
    if (!prompt) return res.status(400).json({ error: "Missing prompt" });

    const parts = [];
    if (referenceDataUrl && typeof referenceDataUrl === "string") {
      const base64 = referenceDataUrl.split(",").pop();
      parts.push({ inlineData: { mimeType: "image/png", data: base64 } });
    }
    parts.push({ text: prompt });

    const contents = [{ role: "user", parts }];
    const modelsToTry = [
      "gemini-2.5-flash-image-preview"
    ];

    let lastError;
    for (const model of modelsToTry) {
      try {
        const response = await genAI.models.generateContent({
          model,
          contents,
          config: { responseModalities: [Modality.IMAGE, Modality.TEXT] },
        });
        const cand = response?.candidates?.[0]?.content?.parts ?? [];
        for (const part of cand) {
          if (part.inlineData) {
            return res.json({
              dataUrl: `data:${part.inlineData.mimeType};base64,${part.inlineData.data}`,
              modelUsed: model,
            });
          }
        }
      } catch (err) {
        lastError = err;
        // continue to next model
      }
    }
    console.error("All models failed", lastError);
    return res.status(502).json({ error: "No image data in response from any model" });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "Internal error" });
  }
});


