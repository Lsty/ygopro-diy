--妖精僧侣 大妖精
function c116810890.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(116810890,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(2,116810890)
	e1:SetCondition(c116810890.drcon)
	e1:SetTarget(c116810890.drtg)
	e1:SetOperation(c116810890.drop)
	c:RegisterEffect(e1)
	--draw1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810890,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(2,116810890)
	e2:SetCondition(c116810890.drcon1)
	e2:SetTarget(c116810890.drtg1)
	e2:SetOperation(c116810890.drop1)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c116810890.sccon)
	e3:SetValue(4)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(116810885,4))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(116810890,2))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e6:SetTarget(c116810890.eqtg)
	e6:SetOperation(c116810890.eqop)
	c:RegisterEffect(e6)
	--spsummon proc
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_DECK)
	e7:SetCountLimit(2,116810900)
	e7:SetCondition(c116810890.spcon)
	e7:SetOperation(c116810890.spop)
	c:RegisterEffect(e7)
	--special summon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(116810890,3))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c116810890.condition)
	e8:SetTarget(c116810890.target)
	e8:SetOperation(c116810890.operation)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_UPDATE_DEFENCE)
	e9:SetValue(400)
	c:RegisterEffect(e9)
	--equip effect
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_EQUIP)
	ea:SetCode(EFFECT_UPDATE_ATTACK)
	ea:SetValue(400)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_EQUIP)
	eb:SetCode(EFFECT_EXTRA_ATTACK)
	eb:SetValue(1)
	c:RegisterEffect(eb)
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_EQUIP)
	ec:SetCode(EFFECT_UPDATE_LEVEL)
	ec:SetValue(3)
	c:RegisterEffect(ec)
end
function c116810890.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c116810890.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c116810890.drop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c116810890.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetCount()==1 and tg~=e:GetHandler() and tg:GetSummonType()==SUMMON_TYPE_FUSION
end
function c116810890.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c116810890.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c116810890.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0x3e6)
end
function c116810890.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6)
end
function c116810890.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c116810890.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c116810890.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c116810890.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c116810890.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c116810890.eqlimit)
	c:RegisterEffect(e1)
end
function c116810890.eqlimit(e,c)
	return c:IsSetCard(0x3e6)
end
function c116810890.spfilter(c)
	return c:IsSetCard(0x3e6) and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x3e6)
end
function c116810890.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c116810890.spfilter,1,nil)
end
function c116810890.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c116810890.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c116810890.cfilter(c)
	return c:IsAbleToHand()
end
function c116810890.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsSetCard(0x13e6)
end
function c116810890.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c116810890.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c116810890.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c116810890.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c116810890.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end