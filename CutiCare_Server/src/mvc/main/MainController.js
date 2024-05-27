const tf = require('@tensorflow/tfjs-node');
const fs = require('fs');
const path = require('path');

// Load the model
let model;

(async () => {
    try {
        const modelPath = 'D:/React/Cuty/CutiCare/CutiCare_Server/config/model/model.json';
        model = await tf.loadLayersModel('file://' + modelPath);
        console.log('Model loaded successfully');

        // After loading the model, evaluate accuracy

        // const accuracy = await evaluateAccuracy('D:/React/Cuty/CutiCare/CutiCare_Server/config/model/dataset/testing');
        // console.log(`Model accuracy: ${accuracy * 100}%`);
    } catch (error) {
        console.error('Error loading model:', error);
    }
})();

// Function to preprocess image
const preprocessImage = (imageBuffer) => {
    return tf.tidy(() => {
        const imageTensor = tf.node.decodeImage(imageBuffer, 3).expandDims(0);
        const resizedImage = tf.image.resizeBilinear(imageTensor, [256, 256]);
        const normalizedImage = resizedImage.div(255.0);
        return normalizedImage;
    });
};

// Function to apply augmentations
const applyAugmentations = (imageTensor) => {
    return tf.tidy(() => {
        let flippedImage  = randomFlipHorizontal(imageTensor);
        const zoomedImage = randomZoom(flippedImage);
        return zoomedImage;
    });
};

// Function to classify image and return raw prediction
const classifyImage = async (imagePath) => {
    try {
        const imageBuffer = fs.readFileSync(imagePath);
        const preprocessedImage = preprocessImage(imageBuffer);
        const augmentedImage = applyAugmentations(preprocessedImage);

        const prediction = model.predict(augmentedImage);
        const predictionData = await prediction.data();

        return predictionData[0]; // Return the raw prediction value
    } catch (error) {
        console.error('Error classifying image:', error);
        throw new Error('Error classifying image');
    }
};

// Function to evaluate model accuracy
const evaluateAccuracy = async (testDataPath) => {
    const rashDir = path.join(testDataPath, 'eczema');
    const noRashDir = path.join(testDataPath, 'normal');
    const rashFiles = fs.readdirSync(rashDir).map(file => path.join(rashDir, file));
    const noRashFiles = fs.readdirSync(noRashDir).map(file => path.join(noRashDir, file));

    let correctPredictions = 0;
    let totalPredictions = 0;

    // Evaluate images in rash directory
    for (const filePath of rashFiles) {
        const prediction = await classifyImage(filePath);
        if (prediction > 0.5) {
            correctPredictions++;
        }
        totalPredictions++;
    }

    // Evaluate images in no_rash directory
    for (const filePath of noRashFiles) {
        const prediction = await classifyImage(filePath);
        if (prediction <= 0.5) {
            correctPredictions++;
        }
        totalPredictions++;
    }

    const accuracy = correctPredictions / totalPredictions;
    return accuracy;
};

// Function to randomly flip images horizontally
function randomFlipHorizontal(image) {
    return tf.tidy(() => {
        const shouldFlip = tf.randomUniform([]).greater(0.5).dataSync()[0];
        return shouldFlip ? tf.image.flipLeftRight(image) : image;
    });
}

// Function to randomly zoom images
function randomZoom(image, zoomRange = 0.1) {
    return tf.tidy(() => {
        const [batch, height, width, channels] = image.shape;
        const zoomFactor = 1 + (Math.random() * 2 - 1) * zoomRange;
        const newHeight = Math.round(height * zoomFactor);
        const newWidth = Math.round(width * zoomFactor);
        const resized = tf.image.resizeBilinear(image, [newHeight, newWidth]);

        const cropHeight = Math.min(newHeight, height);
        const cropWidth = Math.min(newWidth, width);
        const cropTop = Math.floor((newHeight - cropHeight) / 2);
        const cropLeft = Math.floor((newWidth - cropWidth) / 2);

        const cropped = resized.slice([0, cropTop, cropLeft, 0], [-1, cropHeight, cropWidth, -1]);
        return tf.image.resizeBilinear(cropped, [height, width]);
    });
}

// Function to handle the checkRash request
const checkRash = async (req, res) => {
    try {
        const imagePath = req.file.path;
        const prediction = await classifyImage(imagePath);
        const isRash = prediction > 0.5;
        res.json({ isRash: isRash, confidence: prediction });
    } catch (error) {
        console.error('Error processing image:', error);
        res.status(500).send({ error: 'Error processing image' });
    }
};

// Export the checkRash function using CommonJS syntax
module.exports = { checkRash };
