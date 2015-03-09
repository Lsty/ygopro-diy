--神葬「物理结界」
function c14700010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c14700010.target)
	e1:SetOperation(c14700010.activate)
	c:RegisterEffect(e1)
end
function c14700010.filter(c)
	return c:IsSetCard(0x147) and c:GetCode()~=14700010 and c:IsSSetable()
end
function c14700010.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c14700010.desfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable() and c:GetSequence()<5
end
function c14700010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c14700010.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c14700010.filter,tp,LOCATION_DECK,0,1,nil) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
		if ft<0 then return false
		elseif ft>0 then
			return Duel.IsExistingTarget(c14700010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		else
			return Duel.IsExistingTarget(c14700010.desfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		end
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft>0 then
		g=Duel.SelectTarget(tp,c14700010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	else
		g=Duel.SelectTarget(tp,c14700010.desfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14700010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c14700010.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end