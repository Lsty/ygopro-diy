--黑圆桌第十位 Spinne
function c98800008.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c98800008.destg)
	e1:SetOperation(c98800008.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NAGA+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c98800008.spcon)
	e2:SetTarget(c98800008.sptg)
	e2:SetOperation(c98800008.spop)
	c:RegisterEffect(e2)
end
function c98800008.filter(c)
	return c:IsFaceup() and c:GetBaseDefence()<1600 and c:IsDestructable()
end
function c98800008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98800008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98800008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98800008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98800008.desfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:GetBaseDefence()<1600
end
function c98800008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c98800008.desfilter,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c98800008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and (e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) or e:GetHandler():IsPreviousLocation(LOCATION_REMOVED))) or e:GetHandler():IsPreviousLocation(LOCATION_GRAVE))
		and e:GetHandler():IsReason(REASON_EFFECT)
end
function c98800008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
end
function c98800008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
end