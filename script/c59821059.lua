--Idol Master of Chaos and Harmony Fujiwara Miyabi
function c59821059.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,59821028),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c59821059.splimit)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-400)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821059,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,59821059)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c59821059.sptg)
	e3:SetOperation(c59821059.spop)
	c:RegisterEffect(e3)
	--place pcard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821059,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,59821059)
	e4:SetCondition(c59821059.pencon)
	e4:SetTarget(c59821059.pentg)
	e4:SetOperation(c59821059.penop)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c59821059.efilter)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821059,2))
	e6:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c59821059.discon)
	e6:SetCost(c59821059.discost)
	e6:SetTarget(c59821059.distg)
	e6:SetOperation(c59821059.disop)
	c:RegisterEffect(e6)
	--salvate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59821059,3))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCondition(c59821059.salcon)
	e7:SetTarget(c59821059.saltg)
	e7:SetOperation(c59821059.salop)
	c:RegisterEffect(e7)
	--to pzone
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCondition(c59821059.con)
	e8:SetOperation(c59821059.op)
	c:RegisterEffect(e8)
end
function c59821059.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c59821059.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c59821059.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59821059.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c59821059.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821059.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(1900)
	e3:SetReset(RESET_EVENT+0xfe0000)
	tc:RegisterEffect(e3)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
function c59821059.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821059.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821059.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821059.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821059.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821059.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821059.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821059.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_SPELL and Duel.IsChainDisablable(ev)
end
function c59821059.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c59821059.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c59821059.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c59821059.salcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821059.saltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function c59821059.salop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_GRAVE,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,2,2,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c59821059.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821059.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821059.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821059.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821059.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821059.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
