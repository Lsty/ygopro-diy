--怪物猎人 奇面族
function c11112009.initial_effect(c)
    --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112009,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11112009)
	e1:SetTarget(c11112009.target)
	e1:SetOperation(c11112009.operation)
	c:RegisterEffect(e1)
	--destroy immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112009,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11112009)
	e2:SetCondition(c11112009.imcon)
	e2:SetTarget(c11112009.imtg)
	e2:SetOperation(c11112009.imop)
	c:RegisterEffect(e2)
end
function c11112009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end	
function c11112009.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER)
end
function c11112009.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c11112009.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c11112009.cfilter,nil)
	if ct==0 then
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetTargetRange(1,0)
	    e1:SetCode(EFFECT_CHANGE_DAMAGE)
	    e1:SetValue(c11112009.damval)
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
        Duel.RegisterFlagEffect(tp,11112009,RESET_PHASE+PHASE_END,0,1)
	else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c11112009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end	
function c11112009.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,11112009)==0 or bit.band(r,REASON_BATTLE)==0 then return val end
	Duel.ResetFlagEffect(tp,11112009)
	return 0
end
function c11112009.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c11112009.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b) and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)
end
function c11112009.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11112009.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11112009.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11112009.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11112009.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c11112009.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c11112009.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end