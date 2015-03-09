--ºÚÔ²×ÀµÚÆßÎ» Goetz Von Verlichingen
function c98800013.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c98800013.indtg)
	e1:SetValue(c98800013.indval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NAGA+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c98800013.spcon)
	e2:SetTarget(c98800013.sptg)
	e2:SetOperation(c98800013.spop)
	c:RegisterEffect(e2)
end
function c98800013.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x988) and c:IsType(TYPE_MONSTER)
end
function c98800013.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
function c98800013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and (e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) or e:GetHandler():IsPreviousLocation(LOCATION_REMOVED))) or e:GetHandler():IsPreviousLocation(LOCATION_GRAVE))
		and e:GetHandler():IsReason(REASON_EFFECT)
end
function c98800013.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x988)
end
function c98800013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98800013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98800013.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c98800013.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98800013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(500)
		tc:RegisterEffect(e2)
	end
end