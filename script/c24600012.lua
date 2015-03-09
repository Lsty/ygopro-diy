--戏言·七本枪·石丸小呗
function c24600012.initial_effect(c)
	c:SetUniqueOnField(1,0,24600012)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c24600012.spcost)
	e1:SetTarget(c24600012.sptg)
	e1:SetOperation(c24600012.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c24600012.ctcos)
	e2:SetTarget(c24600012.cttar)
	e2:SetOperation(c24600012.ctop)
	c:RegisterEffect(e2)
end
function c24600012.cfilter(c)
	return c:IsSetCard(0x246) and c:IsDiscardable()
end
function c24600012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24600012.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c24600012.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c24600012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24600012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c24600012.ctffilter(c,lv)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:GetLevel()<=lv and not c:IsType(TYPE_XYZ)
end
function c24600012.ctfilter(c,tp)
	return c:IsSetCard(0x246) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c24600012.ctffilter,tp,0,LOCATION_MZONE,1,nil,c:GetLevel())
end
function c24600012.ctcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
		and Duel.IsExistingMatchingCard(c24600012.ctfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c24600012.ctfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
	e:GetHandler():RegisterEffect(e1)
end
function c24600012.cttar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c24600012.ctffilter(e,e:GetLabel()) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c24600012.ctffilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c24600012.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end