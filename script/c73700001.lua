--地上的月兔 铃仙·优昙华院·因幡
function c73700001.initial_effect(c)
	--change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,73700001)
	e1:SetCondition(c73700001.cbcon)
	e1:SetTarget(c73700001.thtg)
	e1:SetOperation(c73700001.cbop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c73700001.atkcon)
	e2:SetOperation(c73700001.atkop)
	c:RegisterEffect(e2)
end
function c73700001.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:IsFaceup() and bt:IsSetCard(0x737) and bt:GetControler()==c:GetControler()
end
function c73700001.filter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c73700001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73700001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73700001.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73700001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function c73700001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c73700001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_BEAST) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73700001,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end