import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import CommentModal from 'components/recipes/CommentModal'

import { handleCommentModal } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    commentModalOpen: state.recipesReducer.commentModalOpen,
    commentRecipeId: state.recipesReducer.commentRecipeId,
    commentTagSelectionId: state.recipesReducer.commentTagSelectionId,
    commentBody: state.recipesReducer.commentBody,
  }),
  {
    handleCommentModal,
  },
)(CommentModal))
