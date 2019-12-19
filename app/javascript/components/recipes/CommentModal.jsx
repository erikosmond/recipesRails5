import React from 'react';
import PropTypes from 'prop-types'
// import { makeStyles } from '@material-ui/core/styles';
import Modal from '@material-ui/core/Modal';

function rand() {
  return Math.round(Math.random() * 20) - 10;
}

function getModalStyle() {
  const top = 50 + rand();
  const left = 50 + rand();

  return {
    top: `${top}%`,
    left: `${left}%`,
    transform: `translate(-${top}%, -${left}%)`,
  };
}

// const useStyles = makeStyles(theme => ({
//   paper: {
//     position: 'absolute',
//     width: 400,
//     backgroundColor: theme.palette.background.paper,
//     border: '2px solid #000',
//     boxShadow: theme.shadows[5],
//     padding: theme.spacing(2, 4, 3),
//   },
// }));

export default function CommentModal(props) {
  const {
    commentModalOpen,
    commentRecipeId,
    commentTagSelectionId,
    commentBody,
    handleCommentModal
  } = props
  // const classes = useStyles();
  // getModalStyle is not a pure function, we roll the style only on the first render
  const [modalStyle] = React.useState(getModalStyle);
  // const [open, setOpen] = React.useState(false);

  // const handleOpen = () => {
  //   setOpen(true);
  // };

  const handleClose = () => {
    // setOpen(false);
    handleCommentModal({
      commentRecipeId,
      commentTagSelectionId,
      commentBody,
      commentModalOpen: false,
    })
  };

  // componentWillReceiveProps(nextProps) {
  //   this.setState(state => ({ ...state, nextProps.ModalOpen }))
  // }

  return (
    <div>
      {/* <button type="button" onClick={handleOpen}>
        Open Modal
      </button> */}
      <Modal
        aria-labelledby="recipe-comment"
        aria-describedby="simple-modal-description"
        open={commentModalOpen}
        onClose={handleClose}
      >
        {/* <div style={modalStyle} className={classes.paper}> */}
        <div style={modalStyle}>
          <h2 id="simple-modal-title">Text in a modal</h2>
          <p id="simple-modal-description">
            Duis mollis, est non commodo luctus, nisi erat porttitor ligula.
          </p>
          {/* <SimpleModal /> */}
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
  handleCommentModal: PropTypes.func.isRequired,
}

CommentModal.defaultProps = {
  commentModalOpen: false,
  commentRecipeId: null,
  commentTagSelectionId: null,
  commentBody: '',
}