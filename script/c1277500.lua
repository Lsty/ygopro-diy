--月世界 爱尔奎特
function c1277500.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1277500,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1277500.target)
	e1:SetOperation(c1277500.operation)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9fc))
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c1277500.splimit)
	c:RegisterEffect(e2)
end
function c1277500.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x9fc) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1277500.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x9fc) 
end
function c1277500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1277500.filter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c1277500.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1277500.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local ae=tc:GetActivateEffect()
	if tc:GetLocation()==LOCATION_GRAVE and ae then
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(ae:GetDescription())
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+RESET_END)
		e1:SetTarget(c1277500.spelltg)
		e1:SetOperation(c1277500.spellop)
		tc:RegisterEffect(e1)
	end

end
function c1277500.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c1277500.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
