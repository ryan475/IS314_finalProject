import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('product-form');
  const addVariantButton = document.getElementById('add-variant');
  const variantsContainer = document.querySelector('#variants-table tbody');
  const variantTemplate = document.getElementById('variant-template').innerHTML;
  let variantIndex = variantsContainer.children.length;  // Track the number of variants

  // Template for adding a new variant row
  const variantTemplate = () => `
  <tr class="variant-fields">
    <td><input type="text" name="product[variants_attributes][${variantIndex}][color]" class="form-control"></td>
    <td><input type="text" name="product[variants_attributes][${variantIndex}][size]" class="form-control"></td>
    <td><input type="number" name="product[variants_attributes][${variantIndex}][quantity]" class="form-control"></td>
    <td><button type="button" class="remove-variant btn btn-danger btn-sm">Remove</button></td>
  </tr>
  `;
  // Add a new variant field when the "Add Variant" button is clicked
  addVariantButton.addEventListener('click', (event) => {
    event.preventDefault();
    variantsTable.insertAdjacentHTML('beforeend', variantTemplate());
    variantIndex++;
  // Function to show feedback messages
  const showFeedback = (message, type = 'success') => {
    const feedbackContainer = document.getElementById('feedback');
    feedbackContainer.innerHTML = `<div class="alert alert-${type}">${message}</div>`;
    setTimeout(() => feedbackContainer.innerHTML = '', 3000); // Remove message after 3 seconds
  };
  // Attach remove event listeners to the newly added remove buttons
  attachRemoveListeners();
  });
  // Function to add a new variant field
  const addVariantField = () => {
    const newVariantFields = variantTemplate.replace(/__index__/g, variantIndex);
    variantsContainer.insertAdjacentHTML('beforeend', newVariantFields);
    variantIndex++;  // Increment the index for new variants
    
    // Attach remove listeners to the newly added remove buttons
    attachRemoveVariantListeners();
    updateProductPreview();  // Update the preview dynamically
  };

  // Attach remove event listeners to all "Remove Variant" buttons
  const attachRemoveVariantListeners = () => {
    document.querySelectorAll('.remove-variant').forEach(button => {
      button.removeEventListener('click', removeVariantField); // Avoid duplicate event listeners
      button.addEventListener('click', removeVariantField);
    });
  };

  // Function to remove a variant field
  const removeVariantField = (event) => {
    event.preventDefault();
    event.target.closest('.variant-fields').remove();  // Remove the row
    updateProductPreview();  // Update the preview after removing
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

// Another DOMContentLoaded for the Filter Form (if used)
document.addEventListener('DOMContentLoaded', () => {
  const filterForm = document.getElementById('filter-form');

  if (filterForm) {
    filterForm.addEventListener('submit', (event) => {
      event.preventDefault();
    
      const formData = new FormData(filterForm);
    
      fetch(filterForm.action, {
        method: 'GET',
        body: formData,
        headers: {
          'Accept': 'application/javascript'
        }
      })
      .then(response => response.text())
      .then(data => {
        document.getElementById('products-list').innerHTML = data;
      });
    });
  }
});