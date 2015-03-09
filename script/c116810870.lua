--妖精女王 琪露诺
function c116810870.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c116810870.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,116810870+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c116810870.sprcon)
	e2:SetOperation(c116810870.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c116810870.immcon)
	e5:SetValue(c116810870.efilter)
	c:RegisterEffect(e5)
end
function c116810870.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c116810870.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_XYZ)
end
function c116810870.spfilter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe) and c:IsSetCard(0x3e6) and c:IsCanBeFusionMaterial() 
end
function c116810870.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_RITUAL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_FUSION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_SYNCHRO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c116810870.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_XYZ)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(116810870,0))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c116810870.rmtg)
	e4:SetOperation(c116810870.rmop)
	c:RegisterEffect(e4)
end
function c116810870.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x3e,0x3e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c116810870.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x3e,0x3e,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.SelectOption(1-tp,aux.Stringid(116810870,1))
	Duel.SelectOption(tp,aux.Stringid(116810870,1))
end
function c116810870.immcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
end
function c116810870.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and (te:IsHasType(0x7e0) or te:IsHasProperty(EFFECT_FLAG_FIELD_ONLY) or te:IsHasProperty(EFFECT_FLAG_OWNER_RELATE)) then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	end
	return false
end