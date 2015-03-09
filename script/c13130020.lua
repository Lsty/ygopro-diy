--命运阴暗 键山雏
function c13130020.initial_effect(c)
	c:SetUniqueOnField(1,0,13130020)
	--summon or set without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13130020,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c13130020.setcost)
	e1:SetTarget(c13130020.settg)
	e1:SetOperation(c13130020.setop)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(c13130020.atkcon)
	e2:SetTarget(c13130020.atktg)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c13130020.spcon)
	c:RegisterEffect(e3)
	--disable and destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetOperation(c13130020.disop)
	c:RegisterEffect(e4)
end
function c13130020.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function c13130020.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c13130020.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13130020.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13130020.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13130020.setfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function c13130020.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c13130020.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c13130020.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c13130020.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13130020.atkcon(e)
	return Duel.GetMatchingGroupCount(c13130020.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)==1
end
function c13130020.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c13130020.spcon(e,se,sp)
	return Duel.GetMatchingGroupCount(c13130020.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)==2
end
function c13130020.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	if (Duel.GetMatchingGroupCount(c13130020.filter,tp,LOCATION_ONFIELD,0,nil)==3 and re:IsActiveType(TYPE_TRAP)) or (Duel.GetMatchingGroupCount(c13130020.filter,tp,LOCATION_ONFIELD,0,nil)==4 and re:IsActiveType(TYPE_SPELL)) or (Duel.GetMatchingGroupCount(c13130020.filter,tp,LOCATION_ONFIELD,0,nil)==5 and re:IsActiveType(TYPE_MONSTER)) then 
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end