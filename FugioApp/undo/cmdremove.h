#ifndef CMDREMOVE_H
#define CMDREMOVE_H

#include <QUndoCommand>
#include <QUuid>
#include <QMultiHash>
#include <QTemporaryFile>

#include <fugio/global_interface.h>
#include <fugio/context_interface.h>
#include <fugio/node_interface.h>

#include "noteitem.h"
#include "contextview.h"

class CmdRemove : public QUndoCommand
{
public:
	explicit CmdRemove( ContextView *pContextView, QByteArray pNodeData, QList<QUuid> pNodeList, QList<QUuid> pGroupList, QMultiMap<QUuid, QUuid> pLinkLst )
		: mContextView( pContextView ), mNodeData( pNodeData ), mNodeList( pNodeList ), mGroupList( pGroupList )
	{
		setText( QObject::tr( "Remove Nodes/Links" ) );

		QSharedPointer<fugio::ContextInterface>		Context = mContextView->context();

		// Check for links that are not connected to nodes within the selection

		for( QUuid Src : pLinkLst.keys() )
		{
			QSharedPointer<fugio::PinInterface> PS = Context->findPin( Src );

			if( PS && !pNodeList.contains( PS->node()->uuid() ) )
			{
				for( QUuid Dst : pLinkLst.values( Src ) )
				{
					QSharedPointer<fugio::PinInterface> PD = Context->findPin( Src );

					if( PD && !pNodeList.contains( PD->node()->uuid() ) )
					{
						mInternalLinkList.insert( Src, Dst );
					}
				}
			}
		}

		// Check for links to nodes outside of the selection

		for( QUuid NID : pNodeList )
		{
			QSharedPointer<fugio::NodeInterface> N = Context->findNode( NID );

			if( N )
			{
				for( auto DstPin : N->enumInputPins() )
				{
					if( DstPin->isConnected() )
					{
						auto SrcPin = DstPin->connectedPin();

						if( !pLinkLst.contains( SrcPin->globalId(), DstPin->globalId() ) )
						{
							mExternalLinkList.insert( SrcPin->globalId(), DstPin->globalId() );
						}
					}
				}
			}

			for( auto SrcPin : N->enumOutputPins() )
			{
				for( auto DstPin : SrcPin->connectedPins() )
				{
					if( !pLinkLst.contains( SrcPin->globalId(), DstPin->globalId() ) )
					{
						mExternalLinkList.insert( SrcPin->globalId(), DstPin->globalId() );
					}
				}
			}
		}
	}

	virtual ~CmdRemove( void )
	{

	}

	virtual void undo( void )
	{
		QSharedPointer<fugio::ContextInterface>		Context = mContextView->context();

		QTemporaryFile		TempFile;

		if( TempFile.open() )
		{
			TempFile.write( mNodeData );

			TempFile.close();
		}

		if( Context->load( TempFile.fileName(), true ) )
		{
		}

		QMap<QUuid,QUuid>	PinMap = mContextView->loadPinIds();

		for( QUuid Src : mInternalLinkList.keys() )
		{
			for( QUuid Dst : mInternalLinkList.values( Src ) )
			{
				Context->connectPins( Src, Dst );
			}
		}

		for( QUuid Src : mExternalLinkList.keys() )
		{
			const QUuid	NewSrc = PinMap.value( Src, Src );

			for( QUuid Dst : mExternalLinkList.values( Src ) )
			{
				const QUuid	NewDst = PinMap.value( Dst, Dst );

				Context->connectPins( NewSrc, NewDst );
			}
		}

		for( QUuid ID : mGroupList )
		{
			mContextView->processGroupLinks( ID );
		}

		mContextView->updateItemVisibility();
	}

	virtual void redo( void )
	{
		QSharedPointer<fugio::ContextInterface>		Context = mContextView->context();

		CHECK_NULL_LINKS( mContextView );

		for( QUuid Src : mExternalLinkList.keys() )
		{
			for( QUuid Dst : mExternalLinkList.values( Src ) )
			{
				Context->disconnectPins( Src, Dst );
			}
		}

		for( QUuid Src : mInternalLinkList.keys() )
		{
			for( QUuid Dst : mInternalLinkList.values( Src ) )
			{
				Context->disconnectPins( Src, Dst );
			}
		}

		for( QUuid ID : mNodeList )
		{
			Context->unregisterNode( ID );
		}

		for( QUuid ID : mNoteList )
		{
			mContextView->noteRemove( ID );
		}

		for( QUuid ID : mGroupList )
		{
			mContextView->groupRemove( ID );
		}

		CHECK_NULL_LINKS( mContextView );
	}

private:
	ContextView					*mContextView;
	QByteArray					 mNodeData;
	QList<QUuid>				 mNodeList;
	QList<QUuid>				 mGroupList;
	QList<QUuid>				 mNoteList;
	QMultiMap<QUuid,QUuid>		 mInternalLinkList;
	QMultiMap<QUuid,QUuid>		 mExternalLinkList;
};

#endif // CMDREMOVE_H

