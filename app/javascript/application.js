import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('product-form');
  const addVariantButton = document.getElementById('add-variant');
  const variantsContainer = document.querySelector('#variants-table tbody');
  let variantIndex = variantsContainer.children.length;  // Track the number of variants

  // Function to add a new variant field
  const addVariantField = () => {
    const template = document.getElementById('variant-template').innerHTML;
    const newVariantFields = template.replace(/__index__/g, variantIndex);
    variantsContainer.insertAdjacentHTML('beforeend', newVariantFields);
    variantIndex++;  // Increment the index for new variants

    attachRemoveVariantListeners();  // Attach event listeners for the new remove buttons
    updateProductPreview();  // Update the preview dynamically
  };

  // Attach remove event listeners to all "Remove Variant" buttons
  const attachRemoveVariantListeners = () => {
    document.querySelectorAll('.remove-variant').forEach(button => {
      button.addEventListener('click', (event) => {
        event.preventDefault();
        event.target.closest('.variant-fields').remove();  // Remove the row
        updateProductPreview();
      });
    });
  };

  // Function to update the product preview dynamically
  const updateProductPreview = () => {
    const name = document.querySelector('input[name="product[name]"]').value;
    const description = document.querySelector('textarea[name="product[description]"]').value;
    const price = document.querySelector('input[name="product[price]"]').value;

    const previewTitle = document.querySelector('.card-title');
    const previewText = document.querySelector('.card-text');

    previewTitle.textContent = name || 'Product Name';
    previewText.innerHTML = `<p>${description || 'Product description goes here.'}</p><p><strong>Price: $</strong> ${price || '0.00'}</p>`;

    const variantsPreviewContainer = document.querySelector('.variants');
    variantsPreviewContainer.innerHTML = '';

    document.querySelectorAll('.variant-fields').forEach(row => {
      const color = row.querySelector('input[name*="[color]"]').value;
      const size = row.querySelector('input[name*="[size]"]').value;
      const quantity = row.querySelector('input[name*="[quantity]"]').value;

      variantsPreviewContainer.innerHTML += `
        <div class="variant">
          <p><strong>Color:</strong> ${color}</p>
          <p><strong>Size:</strong> ${size}</p>
          <p><strong>Quantity:</strong> ${quantity}</p>
        </div>
      `;
    });
  };

  // Event listener for the Add Variant button
  addVariantButton.addEventListener('click', (event) => {
    event.preventDefault();
    addVariantField();
  });

  // Attach event listeners to existing Remove Variant buttons
  attachRemoveVariantListeners();

  // Update product preview on page load
  updateProductPreview();
});
