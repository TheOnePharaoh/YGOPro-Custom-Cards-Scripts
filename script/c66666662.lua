--Eldur, Combustion Dragon
function c66666662.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x29b),1)
	c:EnableReviveLimit()
	--pendulum summon
    aux.EnablePendulumAttribute(c)
    --SS
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c66666662.sscon)
	e1:SetTarget(c66666662.sstg)
	e1:SetOperation(c66666662.ssop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666630,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c66666662.rmvcon)
	e2:SetOperation(c66666662.operation)
	c:RegisterEffect(e2)
	--cannot negate SS
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
    --pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c66666662.pencon)
	e4:SetTarget(c66666662.pentg)
	e4:SetOperation(c66666662.penop)
	c:RegisterEffect(e4)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c66666662.splimit)
	c:RegisterEffect(e5)
    
end

function c66666662.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x29b) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c66666662.ssconfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x29b)
end
function c66666662.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66666662.ssconfilter,1,nil,tp)
end
function c66666662.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66666662.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c66666662.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.SelectYesNo(tp,aux.Stringid(66666662,0))then
		local g=Duel.SelectMatchingCard(tp,c66666662.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c66666662.ssfilter(c,e,tp)
	return c:IsSetCard(0x29b) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c66666662.pencon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c66666662.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc):Filter(Card.IsDestructable,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c66666662.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT) and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c66666662.rmvcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
end
function c66666662.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end		
end