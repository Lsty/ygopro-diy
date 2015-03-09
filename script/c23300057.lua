--窮鼠猫を噛む「吉井 明久」＆「明久の“召喚獣”」
function c23300057.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsCode,23300002),aux.FilterBoolFunction(Card.IsCode,25600002),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c23300057.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c23300057.sprcon)
	e2:SetOperation(c23300057.sprop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCondition(c23300057.retcon1)
	e3:SetTarget(c23300057.rettg)
	e3:SetOperation(c23300057.retop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(0)
	e4:SetCondition(c23300057.retcon2)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c23300057.condition)
	e5:SetTarget(c23300057.target)
	e5:SetOperation(c23300057.operation)
	c:RegisterEffect(e5)
	--change name
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e6:SetValue(25600002)
	c:RegisterEffect(e6)
	--reflect battle dam
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--handes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetOperation(c23300057.hdop)
	c:RegisterEffect(e8)
	--change name
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e9:SetValue(25600002)
	c:RegisterEffect(e9)
	--battle indestructable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
end
function c23300057.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c23300057.spfilter1(c,tp)
	local tpe=c:GetOriginalType()
	return c:IsCode(23300002) and c:IsCanBeFusionMaterial() and ((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToExtraAsCost()) or (bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToDeckAsCost())) and Duel.IsExistingMatchingCard(c23300057.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c23300057.spfilter2(c)
	local tpe=c:GetOriginalType()
	return c:IsCode(25600002) and c:IsCanBeFusionMaterial() and ((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToExtraAsCost()) or (bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToDeckAsCost()))
end
function c23300057.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c23300057.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c23300057.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23300057,0))
	local g1=Duel.SelectMatchingCard(tp,c23300057.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23300057,1))
	local g2=Duel.SelectMatchingCard(tp,c23300057.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c23300057.retcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsHasEffect(23300015)
end
function c23300057.retcon2(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsHasEffect(23300015)
end
function c23300057.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c23300057.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c23300057.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_EXTRA
end
function c23300057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23300057.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c23300057.hdop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if hg:GetCount()==0 then return end
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=hg:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	end
end