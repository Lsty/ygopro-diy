--魔姬的静思
function c66600025.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66600025.target)
	e1:SetOperation(c66600025.activate)
	c:RegisterEffect(e1)
end
function c66600025.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c66600025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c66600025.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c66600025.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66600025.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local opt=Duel.SelectOption(tp,aux.Stringid(66600025,0),aux.Stringid(66600025,1),aux.Stringid(66600025,2))
	e:SetLabel(opt)
end
function c66600025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_ONFIELD)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c66600025.efilter)
		if e:GetLabel()==2 then
			e4:SetLabel(TYPE_MONSTER)
		elseif e:GetLabel()==1 then
			e4:SetLabel(TYPE_TRAP)
		else e4:SetLabel(TYPE_SPELL) end
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c66600025.efilter(e,te)
	return te:IsActiveType(e:GetLabel())
end