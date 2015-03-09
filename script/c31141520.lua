--看不见 米斯蒂娅
function c31141520.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31141520,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,31141521)
	e1:SetTarget(c31141520.target)
	e1:SetOperation(c31141520.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,31141520)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c31141520.con)
	e2:SetTarget(c31141520.atktg)
	e2:SetOperation(c31141520.atkop)
	c:RegisterEffect(e2)
	--splimit
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetRange(LOCATION_GRAVE)
	ea:SetTargetRange(1,0)
	ea:SetTarget(c31141520.splimit)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_SUMMON)
	eb:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	eb:SetRange(LOCATION_GRAVE)
	eb:SetTargetRange(1,0)
	eb:SetTarget(c31141520.splimit)
	c:RegisterEffect(eb)
end
function c31141520.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	return e:GetHandler()==tc
end
function c31141520.splimit(e,c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c31141520.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3d3) and c:IsAbleToGrave()
end
function c31141520.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31141520.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c31141520.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31141520.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c31141520.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d3)
end
function c31141520.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c31141520.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31141520.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c31141520.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c31141520.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end