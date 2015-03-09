--变革者-阿修·克里门森
function c9991450.initial_effect(c)
	--Hyper Synchro
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c9991450.hysyncon)
	e1:SetOperation(c9991450.hysynop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO+0x20)
	c:RegisterEffect(e1)
	--Remove Equip Card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(9991450,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9991450)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9991450.tg1)
	e2:SetOperation(c9991450.op1)
	c:RegisterEffect(e2)
	--Power Siezing
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9991450,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9991450)
	e3:SetTarget(c9991450.tg2)
	e3:SetOperation(c9991450.op2)
	c:RegisterEffect(e3)
end
function c9991450.hysynfilter1(c,lv,syncard,tp)
	return Duel.GetMatchingGroupCount(c9991450.hysynfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,c,lv/c:GetLevel(),tp)~=0 and 
	c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c9991450.hysynfilter2(c,rk,tp)
	return c:GetRank()==rk and (c:IsControler(tp) or c:IsHasEffect(8889997))
		and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR)
end
function c9991450.hysyncon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	if not pe then return Duel.GetMatchingGroupCount(c9991450.hysynfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c:GetLevel(),c,tp)~=0
	else return Group.FromCards(pe:GetOwner()):IsExists(c9991450.hysynfilter1,1,nil,c:GetLevel(),c,tp) end
end
function c9991450.hysynop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler() local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	if not pe then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		m1=Duel.SelectMatchingCard(tp,c9991450.hysynfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetLevel(),c,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		m1=Group.FromCards(pe:GetOwner()):FilterSelect(tp,c9991450.hysynfilter1,1,1,nil,c:GetLevel(),c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	m2=Duel.SelectMatchingCard(tp,c9991450.hysynfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetLevel()/m1:GetFirst():GetLevel(),tp)
	m1:Merge(m2) c:SetMaterial(m1) Duel.SendtoGrave(m1,REASON_MATERIAL+REASON_SYNCHRO)
end
function c9991450.filter1(c)
	local typ=c:GetOriginalType()
	return c:IsAbleToRemove() and c:IsType(TYPE_EQUIP) and (c:IsFaceup() or bit.band(typ,TYPE_MONSTER)>0)
end
function c9991450.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE+LOCATION_GRAVE) and c9991450.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9991450.filter1,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9991450.filter1,tp,LOCATION_SZONE+LOCATION_GRAVE,LOCATION_SZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9991450.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c9991450.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc.IsFaceup and chkc.IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) end
end
function c9991450.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e4)
	end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		c:RegisterEffect(e2)
		c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
end
