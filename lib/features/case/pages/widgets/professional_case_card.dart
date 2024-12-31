import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';

class ProfessionalCaseCard extends StatelessWidget {
  final MyCase caseModel;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProfessionalCaseCard({
    Key? key,
    required this.caseModel,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with patient info and actions
            _buildCardHeader(context),
            
            // Divider
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 1,
            ),
            
            // Case Details
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Case Title
                  Text(
                    caseModel.case_name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppPallete.gradient1,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  
                  // Case Description
                  Text(
                    caseModel.case_name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Additional Case Details
                  _buildCaseMetadata(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // Patient Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: AppPallete.gradient2.withOpacity(0.2),
            child: Icon(
              Icons.person,
              color: AppPallete.gradient1,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          
          // Patient Name and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nasser Ahmed",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppPallete.gradient1,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatDate(DateTime.parse(caseModel.created_at)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          IconButton(
            icon: Icon(
              Icons.edit,
              color: AppPallete.gradient1,
              size: 20,
            ),
            onPressed: onEdit,
            tooltip: 'Edit Case',
          ),
        if (onDelete != null)
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: onDelete,
            tooltip: 'Delete Case',
          ),
      ],
    );
  }

  Widget _buildCaseMetadata(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Case Type
        _buildMetadataChip(
          context,
          icon: Icons.medical_services,
          label: caseModel.case_name,
          color: AppPallete.gradient2,
        ),
        
        // Specialty
        _buildMetadataChip(
          context,
          icon: Icons.category,
          label: caseModel.tags![0]?? " ",
          color: AppPallete.gradient1,
        ),
      ],
    );
  }

  Widget _buildMetadataChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Implement your preferred date formatting
    return '${date.day}/${date.month}/${date.year}';
  }
}