import React from 'react';
import PropTypes from 'prop-types'
// import { makeStyles } from '@material-ui/core/styles';
import Modal from '@material-ui/core/Modal';

function rand() {
  return Math.round(Math.random() * 20) - 10;
}

function getModalStyle() {
  return {
    position: 'absolute',
    top: '20%',
    left: '30%',
    backgroundColor: 'white',
    border: '2px solid #000',
    boxShadow: 5,
    padding: 3,
    width: 400,
  };
}

export default function CommentModal(props) {
  const {
    commentModalOpen,
    commentRecipeId,
    commentTagSelectionId,
    commentBody,
    handleCommentModal,
    recipeOptions,
  } = props
  // getModalStyle is not a pure function, we roll the style only on the first render
  const [modalStyle] = React.useState(getModalStyle);

  const recipeNameFromId = (recipeOptions, id) => {
    for (var i = 0; i < recipeOptions.length; i++) {
      if (recipeOptions[i].value === id) {
        return recipeOptions[i].label
      }
    }
  }

  const handleClose = () => {
    handleCommentModal({
      commentRecipeId,
      commentTagSelectionId,
      commentBody,
      commentModalOpen: false,
    })
  };

  return (
    <div>
      <Modal
        aria-labelledby="recipe-comment"
        aria-describedby="simple-modal-description"
        open={commentModalOpen}
        onClose={handleClose}
      >
        <div style={modalStyle}>
          <h2 id="simple-modal-title">{`${recipeNameFromId(recipeOptions, commentRecipeId)}`}</h2>
          <p id="simple-modal-description">
            Duis mollis, est non commodo luctus, nisi erat porttitor ligula.
          </p>
        </div>
      </Modal>
    </div>
  );
}

CommentModal.propTypes = {
  commentModalOpen: PropTypes.bool,
  commentRecipeId: PropTypes.number,
  commentTagSelectionId: PropTypes.number,
  commentBody: PropTypes.string,
  recipeOptions: PropTypes.arrayOf(PropTypes.shape({})),
  handleCommentModal: PropTypes.func.isRequired,
  allTags: PropTypes.shape({})
}

CommentModal.defaultProps = {
  commentModalOpen: false,
  commentRecipeId: null,
  commentTagSelectionId: null,
  commentBody: '',
  recipeOptions: [],
}