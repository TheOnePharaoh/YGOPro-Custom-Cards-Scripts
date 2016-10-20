--The Future Gear Great Elder Dragon
function c99199022.initial_effect(c)
	c:SetSPSummonOnce(99199022)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xff15),3,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99199022.splimit)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,99199022)
	e2:SetCondition(c99199022.damcon)
	e2:SetTarget(c99199022.damtg)
	e2:SetOperation(c99199022.damop)
	c:RegisterEffect(e2)
	--aclimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c99199022.accon)
	e3:SetValue(c99199022.aclimit)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c99199022.con)
	e4:SetOperation(c99199022.op)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199022,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c99199022.srcon)
	e5:SetTarget(c99199022.srtg)
	e5:SetOperation(c99199022.srop)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99199022,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c99199022.pencon)
	e6:SetCost(c99199022.pencost)
	e6:SetTarget(c99199022.pentg)
	e6:SetOperation(c99199022.penop)
	c:RegisterEffect(e6)
	--splimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c99199022.splimit2)
	e7:SetCondition(c99199022.splimcon2)
	c:RegisterEffect(e7)
end
function c99199022.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99199022.accon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c99199022.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99199022.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:GetBattledGroupCount()>0
end
function c99199022.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c99199022.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetBaseAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c99199022.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c99199022.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c99199022.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99199022.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c99199022.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c99199022.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c99199022.schfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c99199022.confilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff15) and c:GetSummonPlayer()==tp
end
function c99199022.srcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99199022.schfilter,tp,0,LOCATION_MZONE,1,nil) and eg:IsExists(c99199022.confilter,1,nil,tp)
end
function c99199022.srfilter(c)
	return c:IsSetCard(0xff15) and c:IsAbleToHand()
end
function c99199022.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99199022.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99199022.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99199022.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99199022.penfilter4(c)
    return c:IsSetCard(0xff15) and c:IsType(TYPE_PENDULUM)
end
function c99199022.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c99199022.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c99199022.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99199022.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c99199022.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99199022.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c99199022.splimit2(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199022.splimcon2(e)
	return not e:GetHandler():IsForbidden()
end