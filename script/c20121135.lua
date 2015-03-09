--Candy-WrappedGunner
function c20121135.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x777),8,2,c20121135.ovfilter,aux.Stringid(20121135,0),2,c20121135.xyzop)
	c:EnableReviveLimit()
	--ramove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20121135.condition)
	e2:SetCost(c20121135.cost)
	e2:SetTarget(c20121135.target1)
	e2:SetOperation(c20121135.operation1)
	c:RegisterEffect(e2)
end
function c20121135.ovfilter(c)
	return c:IsFaceup() and (c:GetOriginalCode()==20121119 or c:GetOriginalCode()==20121134 or c:GetOriginalCode()==20121129)
end
function c20121135.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(20121135,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c20121135.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end
function c20121135.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(20121135)==0
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(20121135,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20121135.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c20121135.operation1(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(tp,hg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=hg:Select(tp,1,2,nil)
	local g=sg:GetCount()
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	Duel.BreakEffect()
	Duel.Draw(1-tp,g,REASON_EFFECT)
end