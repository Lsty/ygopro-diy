--魔物猎人 雷狼龙
function c6667005.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,6667005)
	e1:SetCondition(c6667005.spcon)
	e1:SetTarget(c6667005.sptg)
	e1:SetOperation(c6667005.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6657005)
	e2:SetTarget(c6667005.tg)
	e2:SetOperation(c6667005.op)
	c:RegisterEffect(e2)
	--control
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e99)
end
function c6667005.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x790)
end
function c6667005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and not g:IsExists(c6667005.cfilter,1,nil)
end
function c6667005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6667005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local token=Duel.CreateToken(tp,6667204)
	Duel.MoveToField(token,tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	end
end
function c6667005.filter(c)
	return c:IsSetCard(0x790) and c:IsFaceup()
end
function c6667005.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6667005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6667005.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c6667005.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c6667005.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_TUNER) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			e1:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			e1:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e1)
		end
	end
end