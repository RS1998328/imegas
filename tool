// image-compressor.html में यह कोड डालें
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('fileInput');
    const compressBtn = document.getElementById('compressBtn');
    const preview = document.getElementById('preview');
    
    fileInput.addEventListener('change', function(e) {
        if (e.target.files[0]) {
            const reader = new FileReader();
            reader.onload = function(event) {
                preview.src = event.target.result;
            };
            reader.readAsDataURL(e.target.files[0]);
        }
    });
    
    compressBtn.addEventListener('click', function() {
        const file = fileInput.files[0];
        if (!file) {
            alert('Please select an image first!');
            return;
        }
        
        const quality = document.getElementById('qualitySlider').value;
        compressImage(file, quality).then(compressedBlob => {
            const downloadLink = document.getElementById('downloadLink');
            downloadLink.href = URL.createObjectURL(compressedBlob);
            downloadLink.style.display = 'block';
        });
    });
});

function compressImage(file, quality) {
    return new Promise((resolve) => {
        const reader = new FileReader();
        reader.onload = function(event) {
            const img = new Image();
            img.src = event.target.result;
            img.onload = function() {
                const canvas = document.createElement('canvas');
                canvas.width = img.width;
                canvas.height = img.height;
                const ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0);
                canvas.toBlob(
                    (blob) => resolve(blob),
                    'image/jpeg',
                    quality / 100
                );
            };
        };
        reader.readAsDataURL(file);
    });
}
