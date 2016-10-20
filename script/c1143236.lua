--ANTI-MATTER Energy
function c1143236.initial_effect(c)
	c:SetUniqueOnField(1,0,1143236)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1143236.target)
	e1:SetOperation(c1143236.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1143236.atktg)
	e2:SetValue(c1143236.atkval)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143236,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetCondition(c1143236.drcon)
	e3:SetTarget(c1143236.drtg)
	e3:SetOperation(c1143236.drop)
	c:RegisterEffect(e3)
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTarget(aux.TargetBoolFunction(c1143236.extratarget))
	c:RegisterEffect(e4)
	if not c1143236.global_check then
		c1143236.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_SZONE)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143236))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143236.extratarget(c)
	return c:IsSetCard(0xaf75) and c:GetLevel()==2 or c:GetLevel()==4
end
function c1143236.desfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsDestructable()
end
function c1143236.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c1143236.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetCode())
end
function c1143236.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaf75) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143236.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c1143236.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1143236.desfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1143236.spfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1143236.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_REMOVED)
end
function c1143236.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c1143236.spfilter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1143236.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c1143236.atktg(e,c)
	return c:IsSetCard(0xaf75)
end
function c1143236.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75)
end
function c1143236.atkval(e,c)
	return Duel.GetMatchingGroupCount(c1143236.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
end
function c1143236.confilter(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==tp and c:IsSetCard(0xaf75)
end
function c1143236.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1143236.confilter,1,nil,tp)
end
function c1143236.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1143236.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
