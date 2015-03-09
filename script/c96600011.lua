--天才钢琴师✟雨宫绫音
function c96600011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c96600011.spcon)
	e1:SetCost(c96600011.cost)
	e1:SetTarget(c96600011.sptg)
	e1:SetOperation(c96600011.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetTarget(c96600011.target)
	e3:SetOperation(c96600011.operation)
	c:RegisterEffect(e3)
end
function c96600011.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x966)
end
function c96600011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c96600011.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c96600011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,96600011)==0 end
	Duel.RegisterFlagEffect(tp,96600011,RESET_PHASE+PHASE_END,0,1)
end
function c96600011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c96600011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c96600011.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x966) and not c:IsType(TYPE_XYZ)
end
function c96600011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c96600011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c96600011.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c96600011.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c96600011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end