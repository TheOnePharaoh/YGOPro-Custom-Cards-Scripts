--S. Vocaloid Ruko Yokune
function c66652240.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),2,false)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66652240,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c66652240.drcon)
	e1:SetTarget(c66652240.drtg)
	e1:SetOperation(c66652240.drop)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66652240.pencon)
	e2:SetCost(c66652240.pencost)
	e2:SetTarget(c66652240.pentg)
	e2:SetOperation(c66652240.penop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c66652240.recon)
	e3:SetTarget(c66652240.rectg)
	e3:SetOperation(c66652240.recop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66652240,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(c66652240.remtg)
	e4:SetOperation(c66652240.remop)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c66652240.con)
	e5:SetOperation(c66652240.op)
	c:RegisterEffect(e5)
end
function c66652240.recfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c66652240.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_FUSION and eg:GetFirst():IsControler(tp) and eg:IsExists(c66652240.recfilter,1,nil)
end
function c66652240.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66652240.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66652240.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c66652240.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c66652240.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c66652240.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66652240.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c66652240.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c66652240.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c66652240.recon(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return eg:GetFirst():GetSummonType()==SUMMON_TYPE_FUSION and eg:GetFirst():IsControler(tp) and eg:IsExists(c66652240.recfilter,1,nil)
end
function c66652240.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c66652240.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function c66652240.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c66652240.remop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c66652240.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652240.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652240.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652240.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652240.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652240.penfilter2,tp,LOCATION_SZONE,0,nil)
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