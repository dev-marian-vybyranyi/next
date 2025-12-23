-- AlterTable
ALTER TABLE `Issue` ADD COLUMN `assignetToUserId` VARCHAR(255) NULL;

-- AddForeignKey
ALTER TABLE `Issue` ADD CONSTRAINT `Issue_assignetToUserId_fkey` FOREIGN KEY (`assignetToUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
